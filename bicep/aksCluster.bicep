// Parameters
@description('Specifies the name of the AKS cluster.')
param name string = 'aks-${uniqueString(resourceGroup().id)}'

@description('Specifies whether to enable API server VNET integration for the cluster or not.')
param enableVnetIntegration bool = true

@description('Specifies the name of the existing virtual network.')
param virtualNetworkName string

@description('Specifies the name of the subnet hosting the worker nodes of the default system agent pool of the AKS cluster.')
param systemAgentPoolSubnetName string = 'SystemSubnet'

@description('Specifies the name of the subnet hosting the worker nodes of the user agent pool of the AKS cluster.')
param userAgentPoolSubnetName string = 'UserSubnet'

@description('Specifies the name of the subnet hosting the pods running in the AKS cluster.')
param podSubnetName string = 'PodSubnet'

@description('Specifies the name of the subnet delegated to the API server when configuring the AKS cluster to use API server VNET integration.')
param apiServerSubnetName string = 'ApiServerSubnet'

@description('Specifies the name of the AKS user-defined managed identity.')
param managedIdentityName string

@description('Specifies the name of the user-defined managed identity used by the application that uses Azure AD workload identity to authenticate against Azure OpenAI.')
param workloadManagedIdentityName string

@description('Specifies the DNS prefix specified when creating the managed cluster.')
param dnsPrefix string = name

@description('Specifies the network plugin used for building Kubernetes network. - azure or kubenet.')
@allowed([
  'azure'
  'kubenet'
])
param networkPlugin string = 'azure'

@description('Specifies the Network plugin mode used for building the Kubernetes network.')
@allowed([
  ''
  'Overlay'
])

param networkPluginMode string = ''

@description('Specifies the network policy used for building Kubernetes network. - calico or azure')
@allowed([
  'azure'
  'calico'
])
param networkPolicy string = 'azure'

@description('Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.')
param podCidr string = '192.168.0.0/16'

@description('A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.')
param serviceCidr string = '172.16.0.0/16'

@description('Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.')
param dnsServiceIP string = '172.16.0.10'

@description('Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.')
@allowed([
  'basic'
  'standard'
])
param loadBalancerSku string = 'standard'

@description('Specifies whether Network Observability is enabled or not. When enabled, network monitoring generates metrics in Prometheus format.')
param monitoringEnabled bool = false

@description('Specifies the IP families are used to determine single-stack or dual-stack clusters. For single-stack, the expected value is IPv4. For dual-stack, the expected values are IPv4 and IPv6.')
param ipFamilies array = ['IPv4']

@description('Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting.')
@allowed([
  'loadBalancer'
  'managedNATGateway'
  'userAssignedNATGateway'
  'userDefinedRouting'
])
param outboundType string = 'loadBalancer'

@description('Specifies the tier of a managed cluster SKU: Paid or Free')
@allowed([
  'Standard'
  'Free'
])
param skuTier string = 'Standard'

@description('Specifies the version of Kubernetes specified when creating the managed cluster.')
param kubernetesVersion string = '1.28.0'

@description('Specifies the administrator username of Linux virtual machines.')
param adminUsername string = 'azureuser'

@description('Specifies the SSH RSA public key string for the Linux nodes.')
param sshPublicKey string

@description('Specifies the tenant id of the Azure Active Directory used by the AKS cluster for authentication.')
param aadProfileTenantId string = subscription().tenantId

@description('Specifies the AAD group object IDs that will have admin role of the cluster.')
param aadProfileAdminGroupObjectIDs array = []

@description('Specifies the node OS upgrade channel. The default is Unmanaged, but may change to either NodeImage or SecurityPatch at GA.	.')
@allowed([
  'NodeImage'
  'None'
  'SecurityPatch'
  'Unmanaged'
])
param nodeOSUpgradeChannel string = 'Unmanaged'

@description('Specifies the upgrade channel for auto upgrade. Allowed values include rapid, stable, patch, node-image, none.')
@allowed([
  'rapid'
  'stable'
  'patch'
  'node-image'
  'none'
])
param upgradeChannel string = 'stable'

@description('Specifies whether to create the cluster as a private cluster or not.')
param enablePrivateCluster bool = true

@description('Specifies the Private DNS Zone mode for private cluster. When the value is equal to None, a Public DNS Zone is used in place of a Private DNS Zone')
param privateDNSZone string = 'none'

@description('Specifies whether to create additional public FQDN for private cluster or not.')
param enablePrivateClusterPublicFQDN bool = true

@description('Specifies whether to enable managed AAD integration.')
param aadProfileManaged bool = true

@description('Specifies whether to  to enable Azure RBAC for Kubernetes authorization.')
param aadProfileEnableAzureRBAC bool = true

@description('Specifies the unique name of of the system node pool profile in the context of the subscription and resource group.')
param systemAgentPoolName string = 'nodepool1'

@description('Specifies the vm size of nodes in the system node pool.')
param systemAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param systemAgentPoolOsDiskSizeGB int = 100

@description('Specifies the OS disk type to be used for machines in a given agent pool. Allowed values are \'Ephemeral\' and \'Managed\'. If unspecified, defaults to \'Ephemeral\' when the VM supports ephemeral OS and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to \'Managed\'. May not be changed after creation. - Managed or Ephemeral')
@allowed([
  'Ephemeral'
  'Managed'
])
param systemAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the number of agents (VMs) to host docker containers in the system node pool. Allowed values must be in the range of 1 to 100 (inclusive). The default value is 1.')
param systemAgentPoolAgentCount int = 3

@description('Specifies the OS type for the vms in the system node pool. Choose from Linux and Windows. Default to Linux.')
@allowed([
  'Linux'
  'Windows'
])
param systemAgentPoolOsType string = 'Linux'

@description('Specifies the OS SKU used by the user agent pool.')
@allowed([
  'Ubuntu'
  'Windows2019'
  'Windows2022'
  'AzureLinux'
])
param systemAgentPoolOsSKU string = 'AzureLinux'

@description('Specifies the maximum number of pods that can run on a node in the system node pool. The maximum number of pods per node in an AKS cluster is 250. The default maximum number of pods per node varies between kubenet and Azure CNI networking, and the method of cluster deployment.')
param systemAgentPoolMaxPods int = 30

@description('Specifies the maximum number of nodes for auto-scaling for the system node pool.')
param systemAgentPoolMaxCount int = 5

@description('Specifies the minimum number of nodes for auto-scaling for the system node pool.')
param systemAgentPoolMinCount int = 3

@description('Specifies whether to enable auto-scaling for the system node pool.')
param systemAgentPoolEnableAutoScaling bool = true

@description('Specifies the virtual machine scale set priority in the system node pool: Spot or Regular.')
@allowed([
  'Spot'
  'Regular'
])
param systemAgentPoolScaleSetPriority string = 'Regular'

@description('Specifies the ScaleSetEvictionPolicy to be used to specify eviction policy for spot virtual machine scale set. Default to Delete. Allowed values are Delete or Deallocate.')
@allowed([
  'Delete'
  'Deallocate'
])
param systemAgentPoolScaleSetEvictionPolicy string = 'Delete'

@description('Specifies the Agent pool node labels to be persisted across all nodes in the system node pool.')
param systemAgentPoolNodeLabels object = {}

@description('Specifies the taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.')
param systemAgentPoolNodeTaints array = []

@description('Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.')
@allowed([
  'OS'
  'Temporary'
])
param systemAgentPoolKubeletDiskType string = 'OS'

@description('Specifies the type for the system node pool: VirtualMachineScaleSets or AvailabilitySet')
@allowed([
  'VirtualMachineScaleSets'
  'AvailabilitySet'
])
param systemAgentPoolType string = 'VirtualMachineScaleSets'

@description('Specifies the availability zones for the agent nodes in the system node pool. Requirese the use of VirtualMachineScaleSets as node pool type.')
param systemAgentPoolAvailabilityZones array = [
  '1'
  '2'
  '3'
]

@description('Specified the scale down mode that effects the cluster autoscaler behavior. If not specified, it defaults to Delete.')
@allowed([
  'Delete'
  'Deallocate'
])
param systemAgentPoolScaleDownMode string = 'Delete'

@description('Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing')
param systemAgentPoolSpotMaxPrice int = -1

@description('Specifies the unique name of of the user node pool profile in the context of the subscription and resource group.')
param userAgentPoolName string = 'nodepool1'

@description('Specifies the vm size of nodes in the user node pool.')
param userAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified..')
param userAgentPoolOsDiskSizeGB int = 100

@description('Specifies the OS disk type to be used for machines in a given agent pool. Allowed values are \'Ephemeral\' and \'Managed\'. If unspecified, defaults to \'Ephemeral\' when the VM supports ephemeral OS and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to \'Managed\'. May not be changed after creation. - Managed or Ephemeral')
@allowed([
  'Ephemeral'
  'Managed'
])
param userAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the number of agents (VMs) to host docker containers in the user node pool. Allowed values must be in the range of 1 to 100 (inclusive). The default value is 1.')
param userAgentPoolAgentCount int = 3

@description('Specifies the OS type for the vms in the user node pool. Choose from Linux and Windows. Default to Linux.')
@allowed([
  'Linux'
  'Windows'
])
param userAgentPoolOsType string = 'Linux'

@description('Specifies the OS SKU used by the user agent pool.')
@allowed([
  'Ubuntu'
  'Windows2019'
  'Windows2022'
  'AzureLinux'
])
param userAgentPoolOsSKU string = 'AzureLinux'

@description('Specifies the maximum number of pods that can run on a node in the user node pool. The maximum number of pods per node in an AKS cluster is 250. The default maximum number of pods per node varies between kubenet and Azure CNI networking, and the method of cluster deployment.')
param userAgentPoolMaxPods int = 30

@description('Specifies the maximum number of nodes for auto-scaling for the user node pool.')
param userAgentPoolMaxCount int = 5

@description('Specifies the minimum number of nodes for auto-scaling for the user node pool.')
param userAgentPoolMinCount int = 3

@description('Specifies whether to enable auto-scaling for the user node pool.')
param userAgentPoolEnableAutoScaling bool = true

@description('Specifies the virtual machine scale set priority in the user node pool: Spot or Regular.')
@allowed([
  'Spot'
  'Regular'
])
param userAgentPoolScaleSetPriority string = 'Regular'

@description('Specifies the ScaleSetEvictionPolicy to be used to specify eviction policy for spot virtual machine scale set. Default to Delete. Allowed values are Delete or Deallocate.')
@allowed([
  'Delete'
  'Deallocate'
])
param userAgentPoolScaleSetEvictionPolicy string = 'Delete'

@description('Specifies the Agent pool node labels to be persisted across all nodes in the user node pool.')
param userAgentPoolNodeLabels object = {}

@description('Specifies the taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.')
@allowed([
  'OS'
  'Temporary'
])
param userAgentPoolNodeTaints array = []

@description('Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.')
param userAgentPoolKubeletDiskType string = 'OS'

@description('Specifies the type for the user node pool: VirtualMachineScaleSets or AvailabilitySet')
@allowed([
  'VirtualMachineScaleSets'
  'AvailabilitySet'
])
param userAgentPoolType string = 'VirtualMachineScaleSets'

@description('Specifies the availability zones for the agent nodes in the user node pool. Requirese the use of VirtualMachineScaleSets as node pool type.')
param userAgentPoolAvailabilityZones array = [
  '1'
  '2'
  '3'
]

@description('Specified the scale down mode that effects the cluster autoscaler behavior. If not specified, it defaults to Delete.')
@allowed([
  'Delete'
  'Deallocate'
])
param userAgentPoolScaleDownMode string = 'Delete'

@description('Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing')
param userAgentPoolSpotMaxPrice int = -1

@description('Specifies whether the httpApplicationRouting add-on is enabled or not.')
param httpApplicationRoutingEnabled bool = false

@description('Specifies whether the Open Service Mesh add-on is enabled or not.')
param openServiceMeshEnabled bool = false

@description('Specifies whether the Istio Service Mesh add-on is enabled or not.')
param istioServiceMeshEnabled bool = false

@description('Specifies whether the Istio Ingress Gateway is enabled or not.')
param istioIngressGatewayEnabled bool = false

@description('Specifies the type of the Istio Ingress Gateway.')
@allowed([
  'Internal'
  'External'
])
param istioIngressGatewayType string = 'External'

@description('Specifies whether the Kubernetes Event-Driven Autoscaler (KEDA) add-on is enabled or not.')
param kedaEnabled bool = false

@description('Specifies whether the Dapr extension is enabled or not.')
param daprEnabled bool = false

@description('Enable high availability (HA) mode for the Dapr control plane')
param daprHaEnabled bool = false

@description('Specifies whether the Flux V2 extension is enabled or not.')
param fluxGitOpsEnabled bool = false

@description('Specifies whether the Vertical Pod Autoscaler is enabled or not.')
param verticalPodAutoscalerEnabled bool = false

@description('Specifies whether the aciConnectorLinux add-on is enabled or not.')
param aciConnectorLinuxEnabled bool = false

@description('Specifies whether the azurepolicy add-on is enabled or not.')
param azurePolicyEnabled bool = true

@description('Specifies whether the Azure Key Vault Provider for Secrets Store CSI Driver addon is enabled or not.')
param azureKeyvaultSecretsProviderEnabled bool = true

@description('Specifies whether the kubeDashboard add-on is enabled or not.')
param kubeDashboardEnabled bool = false

@description('Specifies whether the OIDC issuer is enabled.')
param oidcIssuerProfileEnabled bool = true

@description('Specifies the scan interval of the auto-scaler of the AKS cluster.')
param autoScalerProfileScanInterval string = '10s'

@description('Specifies the scale down delay after add of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterAdd string = '10m'

@description('Specifies the scale down delay after delete of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterDelete string = '20s'

@description('Specifies scale down delay after failure of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterFailure string = '3m'

@description('Specifies the scale down unneeded time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnneededTime string = '10m'

@description('Specifies the scale down unready time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnreadyTime string = '20m'

@description('Specifies the utilization threshold of the auto-scaler of the AKS cluster.')
param autoScalerProfileUtilizationThreshold string = '0.5'

@description('Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster.')
param autoScalerProfileMaxGracefulTerminationSec string = '600'

@description('Specifies the type of node pool expander to be used in scale up. Possible values: most-pods, random, least-waste, priority.')
@allowed([
  'least-waste'
  'most-pods'
  'priority'
  'random'
])
param autoScalerProfileExpander string = 'random'

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

@description('Specifies whether to enable the Azure Blob CSI Driver. The default value is false.')
param blobCSIDriverEnabled bool = false

@description('Specifies whether to enable the Azure Disk CSI Driver. The default value is true.')
param diskCSIDriverEnabled bool = true

@description('Specifies whether to enable the Azure File CSI Driver. The default value is true.')
param fileCSIDriverEnabled bool = true

@description('Specifies whether to enable the Snapshot Controller. The default value is true.')
param snapshotControllerEnabled bool = true

@description('Specifies whether to enable Defender threat detection. The default value is false.')
param defenderSecurityMonitoringEnabled bool = false

@description('Specifies whether to enable ImageCleaner on AKS cluster. The default value is false.')
param imageCleanerEnabled bool = false

@description('Specifies whether ImageCleaner scanning interval in hours.')
param imageCleanerIntervalHours int = 24

@description('Specifies whether to enable Node Restriction. The default value is false.')
param nodeRestrictionEnabled bool = false

@description('Specifies whether to enable Workload Identity. The default value is false.')
param workloadIdentityEnabled bool = false

@description('Specifies whether to create the Application Gateway and enabling the Application Gateway Ingress Controller or not.')
param applicationGatewayEnabled bool = false

@description('Specifies the resource id of the Azure Application Gateway.')
param applicationGatewayId string

@description('Specifies the principal id of the managed identity of the Azure Application Gateway.')
param applicationGatewayManagedIdentityPrincipalId string

@description('Specifies the name of the Key Vault resource.')
param keyVaultName string

@description('Specifies whether to create or not Azure Monitor managed service for Prometheus and Azure Managed Grafana resources.')
param prometheusAndGrafanaEnabled bool = false

@description('Specifies a comma-separated list of additional Kubernetes label keys that will be used in the resource labels metric.')
param metricAnnotationsAllowList string = ''

@description('Specifies a comma-separated list of Kubernetes annotations keys that will be used in the resource labels metric.')
param metricLabelsAllowlist string = ''

@description('Specifies whether to create an Azure OpenAI Service resource or not.')
param openAiEnabled bool = false

@description('Specifies the namespace of the application.')
param namespace string

@description('Specifies the service account of the application.')
param serviceAccountName string

@description('Specifies the object id of an Azure Active Directory user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userId string = ''

// Variables
var diagnosticSettingsName = 'diagnosticSettings'
var logCategories = [
  'kube-apiserver'
  'kube-audit'
  'kube-audit-admin'
  'kube-controller-manager'
  'kube-scheduler'
  'cluster-autoscaler'
  'cloud-controller-manager'
  'guard'
  'csi-azuredisk-controller'
  'csi-azurefile-controller'
  'csi-snapshot-controller'
]
var metricCategories = [
  'AllMetrics'
]
var logs = [for category in logCategories: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: 0
  }
}]
var metrics = [for category in metricCategories: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: 0
  }
}]

// Resources
resource managedIdentityOperatorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'f1a07417-d97a-45cb-824c-7a7467783830'
  scope: subscription()
}

resource readerRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  scope: subscription()
}

resource contributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  scope: subscription()
}

resource keyVaultSecretsUserRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '4633458b-17de-408a-b874-0445c86b69e6'
  scope: subscription()
}

resource MonitoringMetricsPublisherRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '3913510d-42f4-4e42-8a64-420c390055eb'
  scope: subscription()
}

resource cognitiveServicesUserRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'a97b65f3-24c7-4388-baec-2e87135dc908'
  scope: subscription()
}

resource azureKubernetesServiceRBACClusterAdminRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
  scope: subscription()
}

resource azureKubernetesServiceClusterAdminRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8'
  scope: subscription()
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: virtualNetworkName
}

resource systemAgentPoolSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  parent: virtualNetwork
  name: systemAgentPoolSubnetName
}

resource userAgentPoolSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  parent: virtualNetwork
  name: userAgentPoolSubnetName
}

resource podSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  parent: virtualNetwork
  name: podSubnetName
}

resource apiServerSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  parent: virtualNetwork
  name: apiServerSubnetName
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-06-02-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Base'
    tier: skuTier
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: toLower(systemAgentPoolName)
        count: systemAgentPoolAgentCount
        vmSize: systemAgentPoolVmSize
        
        vnetSubnetID: systemAgentPoolSubnet.id
        podSubnetID: networkPluginMode == 'Overlay' ? null : podSubnet.id
        maxPods: systemAgentPoolMaxPods
        osDiskSizeGB: systemAgentPoolOsDiskSizeGB
        osDiskType: systemAgentPoolOsDiskType
        osSKU: systemAgentPoolOsSKU
        osType: systemAgentPoolOsType
        maxCount: systemAgentPoolMaxCount
        minCount: systemAgentPoolMinCount
        scaleDownMode: systemAgentPoolScaleDownMode
        scaleSetPriority: systemAgentPoolScaleSetPriority
        scaleSetEvictionPolicy: systemAgentPoolScaleSetEvictionPolicy == 'Spot' ? systemAgentPoolScaleSetEvictionPolicy : null  
        spotMaxPrice: systemAgentPoolScaleSetEvictionPolicy == 'Spot' ? systemAgentPoolSpotMaxPrice : null
        enableAutoScaling: systemAgentPoolEnableAutoScaling
        mode: 'System'
        type: systemAgentPoolType
        availabilityZones: systemAgentPoolAvailabilityZones
        nodeLabels: systemAgentPoolNodeLabels
        nodeTaints: systemAgentPoolNodeTaints
        kubeletDiskType: systemAgentPoolKubeletDiskType
      }
      {
        name: toLower(userAgentPoolName)
        count: userAgentPoolAgentCount
        vmSize: userAgentPoolVmSize
        vnetSubnetID: userAgentPoolSubnet.id
        podSubnetID: networkPluginMode == 'Overlay' ? null : podSubnet.id
        maxPods: userAgentPoolMaxPods
        osDiskSizeGB: userAgentPoolOsDiskSizeGB
        osDiskType: userAgentPoolOsDiskType
        osSKU: userAgentPoolOsSKU
        osType: userAgentPoolOsType
        maxCount: userAgentPoolMaxCount
        minCount: userAgentPoolMinCount
        scaleDownMode: userAgentPoolScaleDownMode
        scaleSetPriority: userAgentPoolScaleSetPriority
        scaleSetEvictionPolicy: userAgentPoolScaleSetEvictionPolicy == 'Spot' ? userAgentPoolScaleSetEvictionPolicy : null  
        spotMaxPrice: userAgentPoolScaleSetEvictionPolicy == 'Spot' ? userAgentPoolSpotMaxPrice : null
        enableAutoScaling: userAgentPoolEnableAutoScaling
        mode: 'User'
        type: userAgentPoolType
        availabilityZones: userAgentPoolAvailabilityZones
        nodeLabels: userAgentPoolNodeLabels
        nodeTaints: userAgentPoolNodeTaints
        kubeletDiskType: userAgentPoolKubeletDiskType
      }
    ]
    linuxProfile: {
      adminUsername: adminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshPublicKey
          }
        ]
      }
    }
    addonProfiles: {
      ingressApplicationGateway: applicationGatewayEnabled ? {
        config: {
          applicationGatewayId: applicationGatewayEnabled ? applicationGatewayId : null
        }
        enabled: true
      } : {
        enabled: false
      }
      httpApplicationRouting: {
        enabled: httpApplicationRoutingEnabled
      }
      openServiceMesh: {
        enabled: openServiceMeshEnabled
        config: {}
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: workspaceId
        }
      }
      aciConnectorLinux: {
        enabled: aciConnectorLinuxEnabled
      }
      azurepolicy: {
        enabled: azurePolicyEnabled
        config: {
          version: 'v2'
        }
      }
      kubeDashboard: {
        enabled: kubeDashboardEnabled
      }
      azureKeyvaultSecretsProvider: {
        config: {
          enableSecretRotation: 'false'
        }
        enabled: azureKeyvaultSecretsProviderEnabled
      }
    }
    oidcIssuerProfile: {
      enabled: oidcIssuerProfileEnabled
    }
    enableRBAC: true
    networkProfile: {
      networkPlugin: networkPlugin
      networkPluginMode: networkPlugin == 'azure' ? networkPluginMode : ''
      networkPolicy: networkPolicy
      podCidr: networkPlugin == 'kubenet' || networkPluginMode == 'Overlay' ? podCidr : null
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      outboundType: outboundType
      loadBalancerSku: loadBalancerSku
      monitoring: monitoringEnabled ? {
        enabled: true
      } : null
      loadBalancerProfile: null
      ipFamilies: ipFamilies
    }
    workloadAutoScalerProfile: {
      keda: {
        enabled: kedaEnabled
      }
      verticalPodAutoscaler: {
        controlledValues: 'RequestsAndLimits'
        enabled: verticalPodAutoscalerEnabled
        updateMode: 'Off'
      }
    }
    aadProfile: {
      clientAppID: null
      serverAppID: null
      serverAppSecret: null
      managed: aadProfileManaged
      enableAzureRBAC: aadProfileEnableAzureRBAC
      adminGroupObjectIDs: aadProfileAdminGroupObjectIDs
      tenantID: aadProfileTenantId
    }
    autoUpgradeProfile: {
      nodeOSUpgradeChannel: nodeOSUpgradeChannel
      upgradeChannel: upgradeChannel
    }
    azureMonitorProfile: {
      metrics: {
        enabled: prometheusAndGrafanaEnabled
        kubeStateMetrics: {
          metricAnnotationsAllowList: metricAnnotationsAllowList
          metricLabelsAllowlist: metricLabelsAllowlist
        }
      }
    }
    autoScalerProfile: {
      'scan-interval': autoScalerProfileScanInterval
      'scale-down-delay-after-add': autoScalerProfileScaleDownDelayAfterAdd
      'scale-down-delay-after-delete': autoScalerProfileScaleDownDelayAfterDelete
      'scale-down-delay-after-failure': autoScalerProfileScaleDownDelayAfterFailure
      'scale-down-unneeded-time': autoScalerProfileScaleDownUnneededTime
      'scale-down-unready-time': autoScalerProfileScaleDownUnreadyTime
      'scale-down-utilization-threshold': autoScalerProfileUtilizationThreshold
      'max-graceful-termination-sec': autoScalerProfileMaxGracefulTerminationSec
      expander: autoScalerProfileExpander
    }
    apiServerAccessProfile: {
      enablePrivateCluster: enablePrivateCluster
      enableVnetIntegration: enableVnetIntegration
      privateDNSZone: enablePrivateCluster ? privateDNSZone : null
      enablePrivateClusterPublicFQDN: enablePrivateClusterPublicFQDN
      subnetId: apiServerSubnet.id
    }
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: workspaceId
        securityMonitoring: {
          enabled: defenderSecurityMonitoringEnabled
        }
      }
      imageCleaner: {
        enabled: imageCleanerEnabled
        intervalHours: imageCleanerIntervalHours
      }
      nodeRestriction: {
        enabled: nodeRestrictionEnabled
      }
      workloadIdentity: {
        enabled: workloadIdentityEnabled
      }
    }
    serviceMeshProfile: istioServiceMeshEnabled ? {
      istio: {
        components: {
          ingressGateways: istioIngressGatewayEnabled ? [
            {
              enabled: true
              mode: istioIngressGatewayType
            }
          ] : null
        }
      }
      mode: 'Istio'
    } : null
    storageProfile: {
      blobCSIDriver: {
        enabled: blobCSIDriverEnabled
      }
      diskCSIDriver: {
        enabled: diskCSIDriverEnabled
      }
      fileCSIDriver: {
        enabled: fileCSIDriverEnabled
      }
      snapshotController: {
        enabled: snapshotControllerEnabled
      }
    }
  }
}

resource azureKubernetesServiceRBACClusterAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userId)) {
  name: guid(aksCluster.id, userId, azureKubernetesServiceRBACClusterAdminRole.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: azureKubernetesServiceRBACClusterAdminRole.id
    principalType: 'User'
    principalId: userId
  }
}

resource azureKubernetesServiceClusterAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userId)) {
  name: guid(aksCluster.id, userId, azureKubernetesServiceClusterAdminRole.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: azureKubernetesServiceClusterAdminRole.id
    principalType: 'User'
    principalId: userId
  }
}

// AGIC's identity requires "Managed Identity Operator" permission over the user assigned identity of Application Gateway.
resource applicationGatewayAgicManagedIdentityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (applicationGatewayEnabled) {
  name: guid(aksCluster.id, applicationGatewayManagedIdentityPrincipalId, 'managedIdentityOperator')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: managedIdentityOperatorRole.id
    principalType: 'ServicePrincipal'
    principalId: applicationGatewayEnabled ? aksCluster.properties.addonProfiles.ingressApplicationGateway.identity.objectId : ''
  }
}

resource applicationGatewayAgicContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (applicationGatewayEnabled) {
  name: guid(resourceGroup().id, 'ApplicationGateway', 'contributor')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: contributorRole.id
    principalType: 'ServicePrincipal'
    principalId: applicationGatewayEnabled ? aksCluster.properties.addonProfiles.ingressApplicationGateway.identity.objectId : ''
  }
}

resource applicationGatewayAgicReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (applicationGatewayEnabled) {
  name: guid(resourceGroup().id, 'ApplicationGateway', 'reader')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: readerRole.id
    principalType: 'ServicePrincipal'
    principalId: applicationGatewayEnabled ? aksCluster.properties.addonProfiles.ingressApplicationGateway.identity.objectId : ''
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: keyVaultName
}

resource keyVaultSecretsUserApplicationGatewayIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (applicationGatewayEnabled) {
  name: guid(keyVault.id, 'ApplicationGateway', 'keyVaultSecretsUser')
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole.id
    principalType: 'ServicePrincipal'
    principalId: applicationGatewayManagedIdentityPrincipalId
  }
}

resource keyVaultCSIdriverSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (azureKeyvaultSecretsProviderEnabled) {
  name: guid(aksCluster.id, 'CSIDriver', keyVaultSecretsUserRole.id)
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole.id
    principalType: 'ServicePrincipal'
    principalId: aksCluster.properties.addonProfiles.azureKeyvaultSecretsProvider.identity.objectId
  }
}

// This role assignment enables AKS->LA Fast Alerting experience
resource FastAlertingRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aksCluster.id, 'omsagent', MonitoringMetricsPublisherRole.id)
  scope: aksCluster
  properties: {
    roleDefinitionId: MonitoringMetricsPublisherRole.id
    principalId: aksCluster.properties.addonProfiles.omsagent.identity.objectId
    principalType: 'ServicePrincipal'
  }
}

//  This user-defined managed identity used by the workload to connect to the Azure OpenAI resource with a security token issued by Azue Active Directory
resource workloadManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (openAiEnabled) {
  name: workloadManagedIdentityName
  location: location
  tags: tags
}

// Assign the Cognitive Services User role to the user-defined managed identity used by workloads
resource cognitiveServicesUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (openAiEnabled) {
  name:  guid(workloadManagedIdentity.id, cognitiveServicesUserRole.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: cognitiveServicesUserRole.id
    principalId: workloadManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Create federated identity for the user-defined managed identity used by the workload
resource federatedIdentityCredentials 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = if (openAiEnabled && !empty(namespace) && !empty(serviceAccountName)) {
  name: 'WorkloadFederatedIdentityCredentials'
  parent: workloadManagedIdentity
  properties: {
    issuer: aksCluster.properties.oidcIssuerProfile.issuerURL
    subject: 'system:serviceaccount:${namespace}:${serviceAccountName}'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

// Dapr Extension
resource daprExtension 'Microsoft.KubernetesConfiguration/extensions@2022-04-02-preview' = if (daprEnabled) {
  name: 'dapr'
  scope: aksCluster
  properties: {
    extensionType: 'Microsoft.Dapr'
    autoUpgradeMinorVersion: true
    releaseTrain: 'Stable'
    configurationSettings: {
      'global.ha.enabled': '${daprHaEnabled}'
    }
    scope: {
      cluster: {
        releaseNamespace: 'dapr-system'
      }
    }
    configurationProtectedSettings: {}
  }
}

// Flux v2 Extension
resource fluxAddon 'Microsoft.KubernetesConfiguration/extensions@2022-04-02-preview' = if (fluxGitOpsEnabled) {
  name: 'flux'
  scope: aksCluster
  properties: {
    extensionType: 'microsoft.flux'
    autoUpgradeMinorVersion: true
    releaseTrain: 'Stable'
    scope: {
      cluster: {
        releaseNamespace: 'flux-system'
      }
    }
    configurationProtectedSettings: {}
  }
  dependsOn: [ daprExtension ] //Chaining dependencies because of: https://github.com/Azure/AKS-Construction/issues/385
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  scope: aksCluster
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

// Output
output id string = aksCluster.id
output name string = aksCluster.name
output issuerUrl string = aksCluster.properties.oidcIssuerProfile.issuerURL
output workloadManagedIdentityClientId string = workloadManagedIdentity.properties.clientId
output nodeResourceGroup string = aksCluster.properties.nodeResourceGroup
