// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/infobars/modals/test/fake_infobar_translate_modal_consumer.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

@implementation FakeInfobarTranslateModalConsumer
- (void)setupModalViewControllerWithPrefs:(NSDictionary*)prefs {
  self.sourceLanguage = prefs[kSourceLanguagePrefKey];
  self.targetLanguage = prefs[kTargetLanguagePrefKey];
  self.enableTranslateActionButton =
      [prefs[kEnableTranslateButtonPrefKey] boolValue];
  self.updateLanguageBeforeTranslate =
      [prefs[kUpdateLanguageBeforeTranslatePrefKey] boolValue];
  self.displayShowOriginalButton =
      [prefs[kEnableAndDisplayShowOriginalButtonPrefKey] boolValue];
  self.shouldAlwaysTranslate = [prefs[kShouldAlwaysTranslatePrefKey] boolValue];
  self.shouldDisplayNeverTranslateLanguageButton =
      [prefs[kDisplayNeverTranslateLanguagePrefKey] boolValue];
  self.shouldDisplayNeverTranslateSiteButton =
      [prefs[kDisplayNeverTranslateSiteButtonPrefKey] boolValue];
  self.isTranslatableLanguage =
      [prefs[kIsTranslatableLanguagePrefKey] boolValue];
  self.isSiteBlacklisted = [prefs[kIsSiteBlacklistedPrefKey] boolValue];
}
@end
