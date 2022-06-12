variable "user" {
  description = "Login information"
  type        = map
  default     = {
    username = "admin"
    password = "!v3G@!4@Y"
    url      = "https://sandboxapicdc.cisco.com"
  }
}


variable "tenant" {
  description = "tennant information"
  type = string
  default = "devnet_tenant"
}


variable "vrf" {
  type = string
  default = "devnet_vrf"
}

variable "bd" {
  type = map
  default = {
    web_bd = {
      name = "web_bd"
      ip_learning = "yes"
      subnet = "10.1.1.1/24"
      subnet_scope = ["private"]
      
    },
    app_bd = {
      name = "app_bd"
      ip_learning = "yes"
      subnet = "10.2.2.1/24"
      subnet_scope = ["private"]

    },
    db_bd = {
      name = "db_bd"
      ip_learning = "yes"
      subnet = "10.3.3.1/24"
      subnet_scope = ["private"]
    }
  }
}



variable "filters" {
  type = map
  default = {
    filter_https = {
      filter = "https",
      entry = "https",
      protocol = "tcp",
      port = "443"

    },
    filter_sql = {
      filter = "sql",
      entry = "sql",
      protocol = "tcp",
      port = "1433"
    }

  }
}