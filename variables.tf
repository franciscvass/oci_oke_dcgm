# Copyright (c) 2022, 2024 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

### ORM Variables
variable "compartment_ocid" {
  type        = string
  default     = null
  description = "A compartment OCID automatically populated by Resource Manager."
}

variable "current_user_ocid" {
  type        = string
  default     = null
  description = "A user OCID automatically populated by Resource Manager."
}

variable "region" {
  type        = string
  default     = null
  description = "The OCI region where OKE resources will be created."
}

variable "tenancy_ocid" {
  type        = string
  default     = null
  description = "The tenancy id of the OCI Cloud Account in which to create the resources."
}


### OKE Module - Common Variables
variable "create_operator_and_bastion" {
  type        = bool
  default     = true
  description = "Whether to create bastion and operator host."
}

variable "ssh_public_key" {
  type        = string
  description = "The contents of the SSH public key file. Used to allow login for workers/bastion/operator. This public key "
}

variable "state_id" {
  type        = string
  default     = null
  description = "Optional Terraform state_id used to identify the resources of this deployment."
}


### OKE Module - Bastion Variables
variable "bastion_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "A list of CIDR blocks to allow SSH access to the bastion host."
}

variable "bastion_image_os" {
  type        = string
  default     = "Oracle Linux"
  description = "Image ID for created bastion instance."
}

variable "bastion_image_os_version" {
  type        = string
  default     = "8"
  description = "Bastion image operating system version when bastion_image_type = 'platform'."
}

variable "bastion_image_type" {
  type        = string
  default     = "platform"
  description = "Whether to use a platform or custom image for the created bastion instance. When custom is set, the bastion_image_id must be specified."

  validation {
    condition     = contains(["platform", "custom"], var.bastion_image_type)
    error_message = "The bastion_image_type can be only `platform` or `custom`."
  }
}

variable "bastion_image_id" {
  type        = string
  default     = null
  description = "Image ID for created bastion instance."
}

variable "bastion_user" {
  type        = string
  default     = "opc"
  description = "User for SSH access through bastion host."
}


### OKE Module - Operator Variables
variable "create_operator_policy_to_manage_cluster" {
  default     = true
  description = "Whether to create minimal IAM policy to allow the operator host to manage the cluster."
  type        = bool
}

variable "operator_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List with allowed CIDR blocks to connect to the operator host."
}

variable "operator_image_os" {
  type        = string
  default     = "Oracle Linux"
  description = "Operator image operating system name when operator_image_type = 'platform'."
}

variable "operator_image_os_version" {
  type        = string
  default     = "8"
  description = "Operator image operating system version when operator_image_type = 'platform'."
}

variable "operator_image_type" {
  type        = string
  default     = "platform"
  description = "Whether to use a platform or custom image for the created operator instance. When custom is set, the operator_image_id must be specified."

  validation {
    condition     = contains(["platform", "custom"], var.operator_image_type)
    error_message = "The operator_image_type can be only `platform` or `custom`."
  }
}

variable "operator_image_id" {
  type        = string
  default     = null
  description = "Image ID for created operator instance."
}

variable "operator_user" {
  type        = string
  default     = "opc"
  description = "User for SSH access to operator host."
}


### OKE Module - Cluster Variables
variable "create_cluster" {
  type        = bool
  default     = true
  description = "Whether to create the OKE cluster and dependent resources."
}

variable "cluster_name" {
  type        = string
  default     = "oke"
  description = "The name of oke cluster."
}

variable "cni_type" {
  type        = string
  default     = "flannel"
  description = "The CNI for the cluster: 'flannel' or 'npn'. See <a href=https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengpodnetworking.htm>Pod Networking</a>."

  validation {
    condition     = contains(["flannel", "npn"], var.cni_type)
    error_message = "The cni_type can be only `flannel` or `npn`."
  }
}

variable "control_plane_is_public" {
  type        = bool
  default     = true
  description = "Whether the Kubernetes control plane endpoint should be allocated a public IP address to enable access over public internet."
}

variable "control_plane_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of CIDR blocks from which the control plane can be accessed."
}

variable "create_vcn" {
  type        = bool
  default     = true
  description = "Whether to create a Virtual Cloud Network."
}

variable "kubernetes_version" {
  type        = string
  default     = "v1.29.1"
  description = "The version of kubernetes to use when provisioning OKE."
}


### OKE Module - IAM Variables
variable "compartment_id" {
  type        = string
  default     = null
  description = "The compartment id where resources will be created."
}

variable "create_iam_resources" {
  type        = bool
  default     = false
  description = "Whether to create IAM dynamic groups, policies, and defined tags."
}

variable "create_iam_defined_tags" {
  type        = bool
  default     = false
  description = "Whether to create defined tag keys."
}

variable "create_iam_tag_namespace" {
  type        = bool
  default     = false
  description = "Whether to create defined tag namespace."
}

variable "tag_namespace" {
  type        = string
  default     = "oke"
  description = "The tag namespace to use if use_defined_tags=true."
}

variable "use_defined_tags" {
  type        = bool
  default     = false
  description = "Wether to set defined tags on the creted resources. By default only free-form tags are used."
}


### OKE Module - Network Variables
variable "cidr_vcn" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The IPv4 CIDR block the VCN will use."
}

variable "cidr_bastion_subnet" {
  type        = string
  default     = "10.0.0.0/29"
  description = "The IPv4 CIDR block to be used for the bastion subnet."
}

variable "cidr_operator_subnet" {
  type        = string
  default     = "10.0.0.64/29"
  description = "The IPv4 CIDR block to be used for the operator subnet."
}

variable "cidr_cp_subnet" {
  type        = string
  default     = "10.0.0.8/29"
  description = "The IPv4 CIDR block to be used for the OKE control plane endpoint."
}

variable "cidr_int_lb_subnet" {
  type        = string
  default     = "10.0.0.32/27"
  description = "The IPv4 CIDR block to be used for the private load balancer subnet."
}

variable "cidr_pub_lb_subnet" {
  type        = string
  default     = "10.0.128.0/27"
  description = "The IPv4 CIDR block to be used for the public load balancer subnet."
}

variable "cidr_workers_subnet" {
  type        = string
  default     = "10.0.144.0/20"
  description = "The IPv4 CIDR block to be used for the kubernetes workers subnet."
}

variable "cidr_pods_subnet" {
  type        = string
  default     = "10.0.64.0/18"
  description = "The IPv4 CIDR block to be used for the pods subnet."
}

variable "vcn_id" {
  type        = string
  default     = null
  description = "Optional ID of existing VCN. Takes priority over vcn_name filter. Ignored when `create_vcn = true`."
}

variable "ig_route_table_id" {
  default     = null
  description = "Optional ID of existing public subnets route table in VCN."
  type        = string
}

variable "nat_route_table_id" {
  default     = null
  description = "Optional ID of existing private subnets route table in VCN."
  type        = string
}

variable "vcn_name" {
  type        = string
  default     = null
  description = "Display name for the created VCN. Defaults to 'oke' suffixed with the generated Terraform 'state_id' value."
}


## OKE Module - Worker NodePool Variables
variable "gpu_np_size" {
   type        = number
   default     = 0
   description = "The size of the nodepool with GPU shapes."
 }
variable "gpu_np_boot_volume_size" {
   type        = number
   default     = 100
   description = "The size of the boot volume for the nodes in the GPU nodepool."
 }
variable "gpu_np_shape" {
   type        = string
   default     = "VM.GPU.A10.1"
   description = "The compute shape to use for the GPUs nodepool."
 }
variable "gpu_np_placement_ads" {
   type        = list(any)
   default     = []
   description = "List with the ADs where to attempt the placement of the GPU worker nodes."
}

variable "simple_np_flex_shape" {
  type = map(any)
  default = {
    "instanceShape" = "VM.Standard.E4.Flex"
    "ocpus"         = 2
    "memory"        = 16
  }
  description = "The compute shape and configuration to use for the non-GPU kubernetes nodepool."
}

variable "simple_np_size" {
  type        = number
  default     = 1
  description = "The size of the non-GPU kubernetes nodepool."
}

variable "simple_np_boot_volume_size" {
  type        = number
  default     = 50
  description = "The boot volume size for the nodes in the non-GPU kubernetes nodepool."
}


### Helm chart deployments
#variable "deploy_nginx" {
#  type        = bool
#  default     = true
#  description = "Controls the deployment of the nginx helm chart."
#}

#variable "nginx_user_values_override" {
#  type        = string
#  default     = ""
#  description = "User provided values to override the Nginx helm chart defaults and those generated by Terraform using the templates."
#}

variable "dcgm_user_values_override" {
  type        = string
  default     = ""
  description = "User provided values to override the ngcm helm chart defaults and those generated by Terraform using the templates."
}
