// Copyright 2022 VMware, Inc. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

package constants

import (
	"time"
)

const (
	// TanzuCLISystemNamespace  is the namespace for tanzu cli resources
	TanzuCLISystemNamespace = "tanzu-cli-system"

	// CLIPluginImageRepositoryOverrideLabel is the label on the configmap which specifies CLIPlugin image repository override
	CLIPluginImageRepositoryOverrideLabel = "cli.tanzu.vmware.com/cliplugin-image-repository-override"

	// DefaultQPS is the default maximum query per second for the rest config
	DefaultQPS = 200

	// DefaultBurst is the default maximum burst for throttle for the rest config
	DefaultBurst = 200

	// TanzuCLIDefaultCentralPluginDiscoveryImage defines the default discovery image
	// from where the CLI will discover the plugins
	TanzuCLIDefaultCentralPluginDiscoveryImage = "projects.registry.vmware.com/tanzu_cli/plugins/plugin-inventory:latest"

	// DefaultCLIEssentialsPluginGroupName  name of the essentials plugin group which is used to install essential plugins
	DefaultCLIEssentialsPluginGroupName = "vmware-tanzucli/essentials"

	// DefaultDigestExpirationThreshold is the default value for digest expiration threshold
	DefaultDigestExpirationThreshold = 24 * time.Hour
)
