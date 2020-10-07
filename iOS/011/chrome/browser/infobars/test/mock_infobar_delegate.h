// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef IOS_CHROME_BROWSER_INFOBARS_TEST_MOCK_INFOBAR_DELEGATE_H_
#define IOS_CHROME_BROWSER_INFOBARS_TEST_MOCK_INFOBAR_DELEGATE_H_

#include "components/infobars/core/confirm_infobar_delegate.h"

#include "testing/gmock/include/gmock/gmock.h"

// Mock version of ConfirmInfoBarDelegate.
class MockInfobarDelegate : public ConfirmInfoBarDelegate {
 public:
  MockInfobarDelegate();
  ~MockInfobarDelegate() override;

  base::string16 GetMessageText() const override { return base::string16(); }
  InfoBarIdentifier GetIdentifier() const override { return TEST_INFOBAR; }

  MOCK_METHOD0(Accept, bool());
  MOCK_METHOD0(InfoBarDismissed, void());
};

#endif  // IOS_CHROME_BROWSER_INFOBARS_TEST_MOCK_INFOBAR_DELEGATE_H_
