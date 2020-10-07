// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/web/public/web_state_delegate_bridge.h"

#include "ios/web/public/test/fakes/test_browser_state.h"
#include "ios/web/public/test/scoped_testing_web_client.h"
#import "ios/web/test/web_test_with_web_controller.h"
#import "net/base/mac/url_conversions.h"
#import "testing/gtest_mac.h"
#include "testing/platform_test.h"
#import "third_party/ocmock/OCMock/OCMock.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

// A fake of CRWWebStateDelegate to test if the methods in the delegate
// bridge are called normally. Uses BOOLs below to record the calls.
@interface FakeCRWWebStateDelegate : NSObject <CRWWebStateDelegate>
@property(nonatomic) web::WebState* webState;
@property(nonatomic) NSURL* URL;
@property(nonatomic) BOOL contextMenuConfigurationNeeded;
@property(nonatomic) BOOL contextMenuWillPresent;
@property(nonatomic) BOOL contextMenuWillCommitWithAnimator;
@property(nonatomic) BOOL contextMenuDidEnd;
@end

@implementation FakeCRWWebStateDelegate

- (void)webState:(web::WebState*)webState
    contextMenuConfigurationForLinkWithURL:(const GURL&)linkURL
                         completionHandler:
                             (void (^)(UIContextMenuConfiguration*))
                                 completionHandler API_AVAILABLE(ios(13.0)) {
  self.webState = webState;
  self.URL = net::NSURLWithGURL(linkURL);
  self.contextMenuConfigurationNeeded = YES;
}

- (void)webState:(web::WebState*)webState
    contextMenuWillPresentForLinkWithURL:(const GURL&)linkURL
    API_AVAILABLE(ios(13.0)) {
  self.webState = webState;
  self.URL = net::NSURLWithGURL(linkURL);
  self.contextMenuWillPresent = YES;
}

- (void)webState:(web::WebState*)webState
    contextMenuForLinkWithURL:(const GURL&)linkURL
       willCommitWithAnimator:
           (id<UIContextMenuInteractionCommitAnimating>)animator
    API_AVAILABLE(ios(13.0)) {
  self.webState = webState;
  self.URL = net::NSURLWithGURL(linkURL);
  self.contextMenuWillCommitWithAnimator = YES;
}

- (void)webState:(web::WebState*)webState
    contextMenuDidEndForLinkWithURL:(const GURL&)linkURL
    API_AVAILABLE(ios(13.0)) {
  self.webState = webState;
  self.URL = net::NSURLWithGURL(linkURL);
  self.contextMenuDidEnd = YES;
}

@end

namespace web {

// Tests if the iOS 13 context menu delegate methods are correctly called
// via the web state delegate bridge.
class WebStateContextMenuBridgeTest : public web::WebTestWithWebController {
 public:
  WebStateContextMenuBridgeTest() : web::WebTestWithWebController() {}

  FakeCRWWebStateDelegate* MakeFakeCRWWebStateDelegate() {
    FakeCRWWebStateDelegate* web_state_delegate =
        [[FakeCRWWebStateDelegate alloc] init];
    web_state_delegate_bridge_ =
        std::make_unique<web::WebStateDelegateBridge>(web_state_delegate);
    web_state()->SetDelegate(web_state_delegate_bridge_.get());
    return web_state_delegate;
  }

 private:
  std::unique_ptr<web::WebStateDelegateBridge> web_state_delegate_bridge_ =
      nullptr;
};

TEST_F(WebStateContextMenuBridgeTest, IOS13ContextMenuDelegateBridgeTest) {
  if (@available(iOS 13, *)) {
    WKWebView* web_view = [web_controller() ensureWebViewCreated];
    id<WKUIDelegate> ui_delegate = web_view.UIDelegate;

    NSURL* url = [NSURL URLWithString:@"https://google.com/"];
    id element_info = OCMClassMock([WKContextMenuElementInfo class]);
    [[[element_info stub] andReturn:url] linkURL];

    FakeCRWWebStateDelegate* web_state_delegate = MakeFakeCRWWebStateDelegate();
    [ui_delegate webView:web_view
        contextMenuConfigurationForElement:element_info
                         completionHandler:^(id){
                         }];
    EXPECT_EQ(web_state(), web_state_delegate.webState);
    EXPECT_NSEQ(url, web_state_delegate.URL);
    EXPECT_TRUE(web_state_delegate.contextMenuConfigurationNeeded);
    EXPECT_FALSE(web_state_delegate.contextMenuDidEnd);
    EXPECT_FALSE(web_state_delegate.contextMenuWillCommitWithAnimator);
    EXPECT_FALSE(web_state_delegate.contextMenuWillPresent);

    web_state_delegate = MakeFakeCRWWebStateDelegate();
    [ui_delegate webView:web_view contextMenuDidEndForElement:element_info];
    EXPECT_EQ(web_state(), web_state_delegate.webState);
    EXPECT_NSEQ(url, web_state_delegate.URL);
    EXPECT_FALSE(web_state_delegate.contextMenuConfigurationNeeded);
    EXPECT_TRUE(web_state_delegate.contextMenuDidEnd);
    EXPECT_FALSE(web_state_delegate.contextMenuWillCommitWithAnimator);
    EXPECT_FALSE(web_state_delegate.contextMenuWillPresent);

    web_state_delegate = MakeFakeCRWWebStateDelegate();
    [ui_delegate webView:web_view
         contextMenuForElement:element_info
        willCommitWithAnimator:
            [OCMockObject
                mockForProtocol:@protocol(UIContextMenuInteractionDelegate)]];
    EXPECT_EQ(web_state(), web_state_delegate.webState);
    EXPECT_NSEQ(url, web_state_delegate.URL);
    EXPECT_FALSE(web_state_delegate.contextMenuConfigurationNeeded);
    EXPECT_FALSE(web_state_delegate.contextMenuDidEnd);
    EXPECT_TRUE(web_state_delegate.contextMenuWillCommitWithAnimator);
    EXPECT_FALSE(web_state_delegate.contextMenuWillPresent);

    web_state_delegate = MakeFakeCRWWebStateDelegate();
    [ui_delegate webView:web_view
        contextMenuWillPresentForElement:element_info];
    EXPECT_EQ(web_state(), web_state_delegate.webState);
    EXPECT_NSEQ(url, web_state_delegate.URL);
    EXPECT_FALSE(web_state_delegate.contextMenuConfigurationNeeded);
    EXPECT_FALSE(web_state_delegate.contextMenuDidEnd);
    EXPECT_FALSE(web_state_delegate.contextMenuWillCommitWithAnimator);
    EXPECT_TRUE(web_state_delegate.contextMenuWillPresent);
  }
}

}  // namespace web
