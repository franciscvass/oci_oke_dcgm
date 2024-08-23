# Copyright (c) 2022, 2024 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  deploy_from_operator = var.create_operator_and_bastion
  deploy_from_local    = alltrue([!local.deploy_from_operator, var.control_plane_is_public])
}

data "oci_containerengine_cluster_kube_config" "kube_config" {
  count = local.deploy_from_local ? 1 : 0

  cluster_id = module.oke.cluster_id
  endpoint   = "PUBLIC_ENDPOINT"
}

/*
module "nginx" {
  count  = var.deploy_nginx ? 1 : 0
  source = "./helm-module"

  bastion_host    = module.oke.bastion_public_ip
  bastion_user    = var.bastion_user
  operator_host   = module.oke.operator_private_ip
  operator_user   = var.bastion_user
  ssh_private_key = tls_private_key.stack_key.private_key_openssh

  deploy_from_operator = local.deploy_from_operator
  deploy_from_local    = local.deploy_from_local

  deployment_name     = "ingress-nginx"
  helm_chart_name     = "ingress-nginx"
  namespace           = "nginx"
  helm_repository_url = "https://kubernetes.github.io/ingress-nginx"
  # helm_chart_path           = "./ingress-nginx-4.11.0.tgz" or "./ingress-nginx"

  pre_deployment_commands  = []
  post_deployment_commands = []

  helm_template_values_override = templatefile(
    "${path.root}/helm-values-templates/nginx-values.yaml.tpl",
    {
      min_bw        = 100,
      max_bw        = 100,
      pub_lb_nsg_id = module.oke.pub_lb_nsg_id
      state_id      = local.state_id
    }
  )
  helm_user_values_override = try(base64decode(var.nginx_user_values_override), var.nginx_user_values_override)

  kube_config = one(data.oci_containerengine_cluster_kube_config.kube_config.*.content)
  depends_on  = [module.oke]
}
*/

module "dcgm_exporter" {
  source = "./helm-module"

  bastion_host    = module.oke.bastion_public_ip
  bastion_user    = var.bastion_user
  operator_host   = module.oke.operator_private_ip
  operator_user   = var.bastion_user
  ssh_private_key = tls_private_key.stack_key.private_key_openssh

  deploy_from_operator = local.deploy_from_operator
  deploy_from_local    = local.deploy_from_local

  deployment_name     = "dcgm-exporter"
  helm_chart_name     = "dcgm-daemonset-chart"
  namespace           = "dcgm-exporter"
  helm_repository_url = ""
  #helm_chart_path           = "./ingress-nginx-4.11.0.tgz" or "./ingress-nginx"
  helm_chart_path           = "./dcgm-exporter-helm/dcgm-daemonset-chart"

  pre_deployment_commands  = []
  post_deployment_commands = []

  # this override the values.yaml file from chart
  # this is a file present in helm-values-templates folder
  helm_template_values_override = templatefile(
    "${path.root}/helm-values-templates/dcgm-exporter-value.yaml",{}
  )
  
  # this is a file user uploads from ORM 
  #helm_user_values_override = try(base64decode(var.nginx_user_values_override), var.nginx_user_values_override)
  helm_user_values_override = try(base64decode(var.dcgm_user_values_override), var.dcgm_user_values_override)

  kube_config = one(data.oci_containerengine_cluster_kube_config.kube_config.*.content)
  depends_on  = [module.oke]
}
