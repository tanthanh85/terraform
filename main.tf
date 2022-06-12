terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci",

    }
  }
}

# Configure the provider with your Cisco APIC credentials.
provider "aci" {
  # APIC Username
  username = var.user.username
  # APIC Password
  # password = var.user.password
  # APIC URL
  cert_name   = "andy_cert"
  private_key = "admin.key"
  url         = var.user.url
  insecure    = true
}

# Define an ACI Tenant Resource.
resource "aci_tenant" "devnet_tenant" {
  name        = var.tenant
  description = "This is devnet tennant"
}

resource "aci_vrf" "devnet_vrf" {
  name        = var.vrf
  tenant_dn   = aci_tenant.devnet_tenant.id
  description = "This is VRF under devnet tenant"
}

resource "aci_bridge_domain" "devnet_bd" {
  for_each           = var.bd
  name               = each.value.name
  ip_learning        = each.value.ip_learning
  tenant_dn          = aci_tenant.devnet_tenant.id
  relation_fv_rs_ctx = aci_vrf.devnet_vrf.id
}




resource "aci_subnet" "devnet_subnet" {
  for_each  = var.bd
  parent_dn = aci_bridge_domain.devnet_bd[each.key].id
  ip        = each.value.subnet
  scope     = each.value.subnet_scope
}


resource "aci_filter" "devnet_filter" {
  for_each  = var.filters
  tenant_dn = aci_tenant.devnet_tenant.id
  name      = each.value.filter

}

resource "aci_filter_entry" "devnet_filter_entry" {
  for_each    = var.filters
  filter_dn   = aci_filter.devnet_filter[each.key].id
  name        = each.value.entry
  ether_t     = "ipv4"
  prot        = each.value.protocol
  d_from_port = each.value.port
  d_to_port   = each.value.port

}

resource "aci_contract" "devnet_contract" {
  for_each    = var.contracts
  tenant_dn   = aci_tenant.devnet_tenant.id
  name        = each.value.contract
  description = "Contract created by Terraform"
}


resource "aci_contract_subject" "devnet_contract_subject" {
  for_each                     = var.contracts
  contract_dn                  = aci_contract.devnet_contract[each.key].id
  name                         = each.value.subject
  relation_vz_rs_subj_filt_att = [aci_filter.devnet_filter[each.value.filter].id]

}


resource "aci_l2_outside" "devnet_l2out" {
  tenant_dn   = aci_tenant.devnet_tenant.id
  name        = "devnet_layer2_out"
  description = "l2out created by Terraform"
}
resource "aci_tenant" "tenant_for_rest_example" {
  name        = "tenant_for_rest"
  description = "This tenant is created by terraform ACI provider"
}

resource "aci_rest" "rest_l3_ext_out" {
  path       = "/api/node/mo/${aci_tenant.tenant_for_rest_example.id}/out-test_ext.json"
  class_name = "l3extOut"
  content = {
    "name" = "test_ext"
  }
}

data "aci_vrf" "data_devnet_vrf" {
  tenant_dn = aci_tenant.devnet_tenant.id
  name      = "devnet_vrf"
}