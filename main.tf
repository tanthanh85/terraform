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
  cert_name = "andy_cert"
  private_key = "admin.key"
  url      = var.user.url
  insecure = true
}

# Define an ACI Tenant Resource.
resource "aci_tenant" "devnet_tenant" {
    name        = var.tenant
    description = "This is devnet tennant"
}

resource "aci_vrf" "devnet_vrf" {
    name = var.vrf
    tenant_dn = aci_tenant.devnet_tenant.id
    description = "This is VRF under devnet tenant"
}

resource "aci_bridge_domain" "devnet_bd" {
  for_each = var.bd
  name = each.value.name
  ip_learning = each.value.ip_learning
  tenant_dn = aci_tenant.devnet_tenant.id 
  relation_fv_rs_ctx = aci_vrf.devnet_vrf.id
}


resource "aci_subnet" "devnet_subnet" {
  for_each = var.bd
  parent_dn = aci_bridge_domain.devnet_bd[each.key].id
  ip = each.value.subnet
  scope = each.value.subnet_scope
}