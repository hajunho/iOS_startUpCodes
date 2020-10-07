// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef IOS_CHROME_BROWSER_SESSIONS_SESSION_RESTORATION_OBSERVER_H_
#define IOS_CHROME_BROWSER_SESSIONS_SESSION_RESTORATION_OBSERVER_H_

#include <vector>

#include "base/macros.h"
#include "base/observer_list_types.h"

namespace web {
class WebState;
}  // namespace web

// Observer interface for objects interested in Session restoration events.
class SessionRestorationObserver : public base::CheckedObserver {
 public:
  // Invoked before the session restoration starts.
  virtual void WillStartSessionRestoration() {}

  // Invoked when the session restoration is finished.
  virtual void SessionRestorationFinished(
      const std::vector<web::WebState*>& restored_web_states) {}

 protected:
  SessionRestorationObserver() = default;

 private:
  DISALLOW_COPY_AND_ASSIGN(SessionRestorationObserver);
};

#endif  // IOS_CHROME_BROWSER_SESSIONS_SESSION_RESTORATION_OBSERVER_H_
