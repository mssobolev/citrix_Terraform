resource "citrixblx_adc" "blx" {
source = "/root/ADC_TF/BLX/blx-deb-13.1-4.43.tar.gz"
host = {
  ipaddress = var.hostip
  username = "ctx"
  port = 22
  password = "Citrix123"
}
config = {
mgmt_http_port = 9033 
mgmt_https_port = 9044 
mgmt_ssh_port = 9055
}
password = "Citrix123"
}
