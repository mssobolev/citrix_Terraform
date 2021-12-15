resource "random_pet" "my_name" {
  length = 2
}

resource "random_integer" "ip" {
  min = 45
  max = 100
}

resource "random_integer" "ports" {
  min = 8000
  max = 8999
}




data "phpipam_subnet" "subnet" {
  subnet_address = "10.0.1.0"
  subnet_mask    = 24
}

# Reserve the address

resource "phpipam_address" "ip_address_vip" {
  subnet_id   = "${data.phpipam_subnet.subnet.subnet_id}"
  }


data "phpipam_subnet" "subnet_snip" {
  subnet_address = "10.132.0.0"
  subnet_mask    = 24
}

# Reserve the address

resource "phpipam_address" "ip_address_snip" {
  subnet_id   = "${data.phpipam_subnet.subnet_snip.subnet_id}"
  }


data "phpipam_subnet" "subnet_snip2" {
  subnet_address = "10.0.70.0"
  subnet_mask    = 24
}


resource "phpipam_address" "ip_address_snip2" {
  subnet_id   = "${data.phpipam_subnet.subnet_snip2.subnet_id}"
  }

# WEB server on local docker

resource "docker_image" "webserver" {
  name         = "httpd:2.4"
  keep_locally = false
}


resource "docker_container" "web" {
  image = docker_image.webserver.latest
  name  = "web-${random_integer.ip.result}"
  ports {
    internal = 80
    external = "${random_integer.ports.result}"
  }
}

# ADC configuration

resource "citrixadc_nsip" "tf_snip" {
    ipaddress = "${phpipam_address.ip_address_snip.ip_address}"
    type = "SNIP"
   # netmask = "${data.phpipam_subnet.subnet_snip.subnet_mask}"
    netmask = "255.255.255.0"
    dynamicrouting = "ENABLED"
}


resource "citrixadc_nsip" "snip2" {
    ipaddress = "${phpipam_address.ip_address_snip2.ip_address}"
    type = "SNIP"
    netmask = "255.255.255.0"
    mgmtaccess = "ENABLED"
    dynamicrouting = "ENABLED"
}



resource "citrixadc_lbvserver" "tf_lb" {

  name = "tf_lb_${random_pet.my_name.id}"
  ipv46 = "${phpipam_address.ip_address_vip.ip_address}"
  lbmethod = "ROUNDROBIN"
  port = 80
  servicetype = "HTTP"
}

resource "citrixadc_service" "tf_ser" {
  name = "tf_service_${random_integer.ports.result}"
  ip = "172.16.70.31"
  servicetype  = "HTTP"
  port = "${random_integer.ports.result}"
}

resource "citrixadc_lbvserver_service_binding" "tf_binding" {
  name = citrixadc_lbvserver.tf_lb.name
  servicename = citrixadc_service.tf_ser.name
  weight = 1
}

