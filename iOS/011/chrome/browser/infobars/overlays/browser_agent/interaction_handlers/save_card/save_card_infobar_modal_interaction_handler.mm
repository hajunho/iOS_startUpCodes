// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/infobars/overlays/browser_agent/interaction_handlers/save_card/save_card_infobar_modal_interaction_handler.h"

#include "components/autofill/core/browser/payments/autofill_save_card_infobar_delegate_mobile.h"
#include "ios/chrome/browser/infobars/infobar_ios.h"
#import "ios/chrome/browser/infobars/overlays/browser_agent/interaction_handlers/save_card/save_card_infobar_modal_overlay_request_callback_installer.h"
#include "ios/chrome/browser/main/browser.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

SaveCardInfobarModalInteractionHandler::
    SaveCardInfobarModalInteractionHandler() = default;

SaveCardInfobarModalInteractionHandler::
    ~SaveCardInfobarModalInteractionHandler() = default;

#pragma mark - Public

void SaveCardInfobarModalInteractionHandler::UpdateCredentials(
    InfoBarIOS* infobar,
    base::string16 cardholder_name,
    base::string16 expiration_date_month,
    base::string16 expiration_date_year) {
  infobar->set_accepted(GetInfoBarDelegate(infobar)->UpdateAndAccept(
      cardholder_name, expiration_date_month, expiration_date_year));
}

void SaveCardInfobarModalInteractionHandler::LoadURL(InfoBarIOS* infobar,
                                                     GURL url) {
  GetInfoBarDelegate(infobar)->OnLegalMessageLinkClicked(url);
}

void SaveCardInfobarModalInteractionHandler::PerformMainAction(
    InfoBarIOS* infobar) {
  NOTREACHED() << "SaveCard does not use standard Infobar Accept action.";
}

#pragma mark - Private

std::unique_ptr<InfobarModalOverlayRequestCallbackInstaller>
SaveCardInfobarModalInteractionHandler::CreateModalInstaller() {
  return std::make_unique<SaveCardInfobarModalOverlayRequestCallbackInstaller>(
      this);
}

autofill::AutofillSaveCardInfoBarDelegateMobile*
SaveCardInfobarModalInteractionHandler::GetInfoBarDelegate(
    InfoBarIOS* infobar) {
  autofill::AutofillSaveCardInfoBarDelegateMobile* delegate =
      autofill::AutofillSaveCardInfoBarDelegateMobile::FromInfobarDelegate(
          infobar->delegate());
  DCHECK(delegate);
  return delegate;
}
