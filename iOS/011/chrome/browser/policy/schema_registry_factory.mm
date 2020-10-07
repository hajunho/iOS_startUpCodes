// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/policy/schema_registry_factory.h"

#include "base/check.h"
#include "components/policy/core/common/policy_namespace.h"
#include "components/policy/core/common/schema.h"
#include "components/policy/core/common/schema_registry.h"
#include "ios/chrome/browser/browser_state/chrome_browser_state.h"
#include "ios/chrome/browser/policy/policy_features.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

std::unique_ptr<policy::SchemaRegistry> BuildSchemaRegistryForBrowserState(
    ChromeBrowserState* browser_state,
    const policy::Schema& chrome_schema,
    policy::CombinedSchemaRegistry* global_registry) {
  DCHECK(IsEnterprisePolicyEnabled());
  DCHECK(!browser_state->IsOffTheRecord());

  auto registry = std::make_unique<policy::SchemaRegistry>();

  if (chrome_schema.valid()) {
    registry->RegisterComponent(
        policy::PolicyNamespace(policy::POLICY_DOMAIN_CHROME, ""),
        chrome_schema);
  }
  registry->SetDomainReady(policy::POLICY_DOMAIN_CHROME);

  if (global_registry) {
    global_registry->Track(registry.get());
  }

  return registry;
}
