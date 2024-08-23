# Copyright (c) 2022, 2024 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_identity_tenancy" "tenant_details" {

  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home_region" {

  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}

data "oci_identity_availability_domains" "ads" {

  compartment_id = var.tenancy_ocid
}

data "oci_core_shapes" "gpu_shapes" {
  for_each = { for entry in data.oci_identity_availability_domains.ads.availability_domains : entry.name => entry.id } 
  compartment_id      = var.compartment_id
  availability_domain = each.key
  filter {
    name   = "name"
    values = [var.gpu_np_shape]
  }
}