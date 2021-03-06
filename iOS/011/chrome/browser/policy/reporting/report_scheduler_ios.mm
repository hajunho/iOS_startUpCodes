// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "ios/chrome/browser/policy/reporting/report_scheduler_ios.h"

#include "ios/chrome/browser/application_context.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

namespace enterprise_reporting {

ReportSchedulerIOS::ReportSchedulerIOS() = default;

ReportSchedulerIOS::~ReportSchedulerIOS() = default;

PrefService* ReportSchedulerIOS::GetLocalState() {
  return GetApplicationContext()->GetLocalState();
}

void ReportSchedulerIOS::StartWatchingUpdatesIfNeeded(
    base::Time last_upload,
    base::TimeDelta upload_interval) {
  // Not used on iOS because there is no in-app auto-update.
}

void ReportSchedulerIOS::StopWatchingUpdates() {
  // Not used on iOS because there is no in-app auto-update.
}

void ReportSchedulerIOS::SaveLastUploadVersion() {
  // Not used on iOS because there is no in-app auto-update.
}

}  // namespace enterprise_reporting
