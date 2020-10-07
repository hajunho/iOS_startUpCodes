// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef IOS_CHROME_BROWSER_DISCOVER_FEED_DISCOVER_FEED_SERVICE_FACTORY_H_
#define IOS_CHROME_BROWSER_DISCOVER_FEED_DISCOVER_FEED_SERVICE_FACTORY_H_

#include "base/no_destructor.h"
#include "components/keyed_service/ios/browser_state_keyed_service_factory.h"

class ChromeBrowserState;
class DiscoverFeedService;

// Singleton that owns all DiscoverFeedServices and associates them with
// ChromeBrowserState.
class DiscoverFeedServiceFactory : public BrowserStateKeyedServiceFactory {
 public:
  static DiscoverFeedService* GetForBrowserState(
      ChromeBrowserState* browser_state);

  static DiscoverFeedServiceFactory* GetInstance();

 private:
  friend class base::NoDestructor<DiscoverFeedServiceFactory>;

  DiscoverFeedServiceFactory();
  ~DiscoverFeedServiceFactory() override;

  // BrowserStateKeyedServiceFactory implementation.
  std::unique_ptr<KeyedService> BuildServiceInstanceFor(
      web::BrowserState* context) const override;

  DISALLOW_COPY_AND_ASSIGN(DiscoverFeedServiceFactory);
};

#endif  // IOS_CHROME_BROWSER_DISCOVER_FEED_DISCOVER_FEED_SERVICE_FACTORY_H_
