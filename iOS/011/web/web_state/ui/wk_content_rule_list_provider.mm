// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/web/web_state/ui/wk_content_rule_list_provider.h"

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#include "ios/web/public/browser_state.h"
#include "ios/web/public/browsing_data/cookie_blocking_mode.h"
#import "ios/web/web_state/ui/wk_content_rule_list_util.h"
#import "ios/web/web_state/ui/wk_web_view_configuration_provider.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

namespace web {

WKContentRuleListProvider::WKContentRuleListProvider(
    BrowserState* browser_state)
    : browser_state_(browser_state), weak_ptr_factory_(this) {
  base::WeakPtr<WKContentRuleListProvider> weak_this =
      weak_ptr_factory_.GetWeakPtr();
  [WKContentRuleListStore.defaultStore
      compileContentRuleListForIdentifier:@"block"
                   encodedContentRuleList:CreateCookieBlockingJsonRuleList(
                                              CookieBlockingMode::kBlock)
                        completionHandler:^(WKContentRuleList* rule_list,
                                            NSError* error) {
                          if (!weak_this.get()) {
                            return;
                          }
                          block_content_rule_list_ = rule_list;
                          InstallContentRuleLists();
                        }];
  [WKContentRuleListStore.defaultStore
      compileContentRuleListForIdentifier:@"block-third-party"
                   encodedContentRuleList:
                       CreateCookieBlockingJsonRuleList(
                           CookieBlockingMode::kBlockThirdParty)
                        completionHandler:^(WKContentRuleList* rule_list,
                                            NSError* error) {
                          if (!weak_this.get()) {
                            return;
                          }
                          block_third_party_content_rule_list_ = rule_list;
                          InstallContentRuleLists();
                        }];
}

WKContentRuleListProvider::~WKContentRuleListProvider() {}

void WKContentRuleListProvider::UpdateContentRuleLists(
    base::OnceCallback<void(bool)> callback) {
  if (update_callback_) {
    std::move(update_callback_).Run(false);
  }
  update_callback_ = std::move(callback);
  InstallContentRuleLists();
}

void WKContentRuleListProvider::InstallContentRuleLists() {
  UninstallContentRuleLists();
  switch (browser_state_->GetCookieBlockingMode()) {
    case CookieBlockingMode::kAllow:
      if (update_callback_) {
        std::move(update_callback_).Run(true);
      }
      break;
    case CookieBlockingMode::kBlockThirdParty:
      if (block_third_party_content_rule_list_) {
        [user_content_controller_
            addContentRuleList:block_third_party_content_rule_list_];
        if (update_callback_) {
          std::move(update_callback_).Run(true);
        }
      }
      break;
    case CookieBlockingMode::kBlock:
      if (block_content_rule_list_) {
        [user_content_controller_ addContentRuleList:block_content_rule_list_];
        if (update_callback_) {
          std::move(update_callback_).Run(true);
        }
      }
      break;
  }
}

void WKContentRuleListProvider::UninstallContentRuleLists() {
  if (block_content_rule_list_) {
    [user_content_controller_ removeContentRuleList:block_content_rule_list_];
  }
  if (block_third_party_content_rule_list_) {
    [user_content_controller_
        removeContentRuleList:block_third_party_content_rule_list_];
  }
}

void WKContentRuleListProvider::SetUserContentController(
    WKUserContentController* user_content_controller) {
  user_content_controller_ = user_content_controller;
  InstallContentRuleLists();
}

}  // namespace web
