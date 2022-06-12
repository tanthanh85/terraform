variable "user" {
  description = "Login information"
  type        = map(any)
  default = {
    username = "admin"
    password = "!v3G@!4@Y"
    url      = "https://sandboxapicdc.cisco.com"
  }
}


variable "tenant" {
  description = "tennant information"
  type        = string
  default     = "devnet_tenant"
}


variable "vrf" {
  type    = string
  default = "devnet_vrf"
}

variable "bd" {
  type = map(any)
  default = {
    web_bd = {
      name         = "web_bd"
      ip_learning  = "yes"
      subnet       = "10.1.1.1/24"
      subnet_scope = ["private"]

    },
    app_bd = {
      name         = "app_bd"
      ip_learning  = "yes"
      subnet       = "10.2.2.1/24"
      subnet_scope = ["private"]

    },
    db_bd = {
      name         = "db_bd"
      ip_learning  = "yes"
      subnet       = "10.3.3.1/24"
      subnet_scope = ["private"]
    }
  }
}



variable "filters" {
  type = map(any)
  default = {
    filter_https = {
      filter   = "https",
      entry    = "https",
      protocol = "tcp",
      port     = "443"

    },
    filter_sql = {
      filter   = "sql",
      entry    = "sql",
      protocol = "tcp",
      port     = "1433"
    }

  }
}


variable "contracts" {
  description = "This is all devnet contracts belong to devnet tenant"
  type        = map(any)
  default = {
    contract_web = {
      contract = "web",
      subject  = "https",
      filter   = "filter_https"
    },
    contact_sql = {
      contract = "sql",
      subject  = "sql",
      filter   = "filter_sql"
    }
  }
}
variable "l3out" {
  type = object({
    name        = string
    description = string
  })
  default = {
    name        = "corp_l3"
    description = "Created Using Terraform"
  }
}