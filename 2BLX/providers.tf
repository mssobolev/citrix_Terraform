terraform {
    required_providers {
        citrixadc = {
            source = "citrix/citrixadc"
        }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}
provider "citrixadc" {
 #endpoint = "http://172.16.70.35:9033"
  endpoint = format("http://%s:9033", var.hostip)
  username = "nsroot"
  password = "Citrix123"
 }

provider "citrixblx" {
}
