terraform {
    required_providers {
        citrixadc = {
            source = "citrix/citrixadc"
        }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
    phpipam = {
      source  = "Ouest-France/phpipam"
    }
  }
}
provider "citrixadc" {
  endpoint = "http://10.0.70.131:80"
  username = "tf"
  password = "Citrix123"
 }

provider "phpipam" {
  app_id   = "app0"
  endpoint = "http://172.16.70.35/phpipam/api"
  password = "Citrix123"
  username = "Admin"
  insecure = "true"
}

