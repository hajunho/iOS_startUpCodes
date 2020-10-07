// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "ios/chrome/browser/policy/policy_features.h"

#include <string>

#include "base/command_line.h"
#include "components/version_info/version_info.h"
#include "ios/chrome/browser/chrome_switches.h"
#include "ios/chrome/common/channel_info.h"
#include "ios/web/common/features.h"

const base::Feature kEditBookmarksIOS{"EditBookmarksIOS",
                                      base::FEATURE_DISABLED_BY_DEFAULT};

const base::Feature kManagedBookmarksIOS{"ManagedBookmarksIOS",
                                         base::FEATURE_DISABLED_BY_DEFAULT};

const base::Feature kURLBlocklistIOS{"URLBlocklistIOS",
                                     base::FEATURE_DISABLED_BY_DEFAULT};

namespace {

bool HasSwitch(const std::string& switch_name) {
  // Most policy features must be controlled via the command line because policy
  // infrastructure must be initialized before about:flags or field trials.
  // Using a command line flag is the only way to control these features at
  // runtime.
  base::CommandLine* command_line = base::CommandLine::ForCurrentProcess();
  return command_line->HasSwitch(switch_name);
}

// Returns true if the current command line contains the
// |kDisableEnterprisePolicy| switch.
bool IsDisableEnterprisePolicySwitchPresent() {
  return HasSwitch(switches::kDisableEnterprisePolicy);
}

}  // namespace

bool IsChromeBrowserCloudManagementEnabled() {
  // This method is called very early during the launch sequence (inside
  // IOSChromeMainParts::PreCreateThreads). At that point, the FeatureList API
  // isn't ready yet, so neither Finch experiments nor first-run field trials
  // can be used for progressive rollout. To ensure adequate coverage of both
  // the "CBCM disabled" and "CBCM enabled" code paths, CBCM is enabled at 100%
  // on Beta and 0% on all other channels (CBCM is disabled by default). This
  // allows monitoring crashes for both code paths while allowing early adopters
  // to use CBCM on the Beta channel.
  return HasSwitch(switches::kEnableChromeBrowserCloudManagement) ||
         GetChannel() == version_info::Channel::BETA;
}

bool IsEditBookmarksIOSEnabled() {
  return base::FeatureList::IsEnabled(kEditBookmarksIOS);
}

bool IsEnterprisePolicyEnabled() {
  return !IsDisableEnterprisePolicySwitchPresent();
}

bool ShouldInstallEnterprisePolicyHandlers() {
  return IsEnterprisePolicyEnabled();
}

bool ShouldInstallManagedBookmarksPolicyHandler() {
  return HasSwitch(switches::kInstallManagedBookmarksHandler);
}

bool IsManagedBookmarksEnabled() {
  return ShouldInstallManagedBookmarksPolicyHandler() &&
         base::FeatureList::IsEnabled(kManagedBookmarksIOS);
}

bool ShouldInstallURLBlocklistPolicyHandlers() {
  return HasSwitch(switches::kInstallURLBlocklistHandlers);
}

bool IsURLBlocklistEnabled() {
  return ShouldInstallURLBlocklistPolicyHandlers() &&
         base::FeatureList::IsEnabled(kURLBlocklistIOS) &&
         // The error page shown for blocked URLs requires
         // |web::features::kUseJSForErrorPage| to be enabled.
         base::FeatureList::IsEnabled(web::features::kUseJSForErrorPage);
}
