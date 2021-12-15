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
  subnet_address = "10.132.0.0"
  subnet_mask    = 24
}

# Reserve the address

resource "phpipam_address" "ip_address" {
  subnet_id   = "${data.phpipam_subnet.subnet.subnet_id}"
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

resource "citrixadc_lbvserver" "tf_lb" {

  name = "tf_lb_${random_pet.my_name.id}"
//#ipv46 = "10.0.1.${random_integer.ip.result}"
  ipv46 = "${phpipam_address.ip_address.ip_address}"
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

