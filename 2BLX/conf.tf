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

resource "random_integer" "ports2" {
  min = 8000
  max = 8999
}

# WEB серверы на Docker

resource "docker_image" "webserver" {
  name         = "httpd:2.4"
  keep_locally = false
}


resource "docker_container" "web1" {
  image = docker_image.webserver.latest
  name  = "web-${random_integer.ports.result}"
  ports {
    internal = 80
    external = "${random_integer.ports.result}"
  }
}


resource "docker_container" "web2" {
  image = docker_image.webserver.latest
  name  = "web-${random_integer.ports2.result}"
  ports {
    internal = 80
    external = "${random_integer.ports2.result}"
  }
}


#Настройка Citrix ADC

resource "citrixadc_nsfeature" "tf_nsfeature" {
    cs = true
    lb = true
    ssl = true
    depends_on = [citrixblx_adc.blx]
}

resource "citrixadc_lbvserver" "tf_lb" {

  name = "tf_lb_${random_pet.my_name.id}"
  ipv46 = "192.0.0.10"
  lbmethod = "ROUNDROBIN"
  port = 80
  servicetype = "HTTP"
  depends_on = [citrixblx_adc.blx]
}

resource "citrixadc_service" "tf_ser1" {
  name = "tf_service_${random_integer.ports.result}"
  ip = "172.16.70.31"
  servicetype  = "HTTP"
  port = "${random_integer.ports.result}"
  depends_on = [citrixblx_adc.blx]
}


resource "citrixadc_service" "tf_ser2" {
  name = "tf_service_${random_integer.ports2.result}"
  ip = "172.16.70.31"
  servicetype  = "HTTP"
  port = "${random_integer.ports2.result}"
  depends_on = [citrixblx_adc.blx]
}


resource "citrixadc_lbvserver_service_binding" "tf_binding" {
  name = citrixadc_lbvserver.tf_lb.name
  servicename = citrixadc_service.tf_ser1.name
  weight = 1
  depends_on = [citrixblx_adc.blx]
}

resource "citrixadc_lbvserver_service_binding" "tf_binding2" {
  name = citrixadc_lbvserver.tf_lb.name
  servicename = citrixadc_service.tf_ser2.name
  weight = 1
  depends_on = [citrixblx_adc.blx]
}
