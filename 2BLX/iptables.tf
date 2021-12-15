resource "null_resource" "nikakoyinstance" {
provisioner "remote-exec" {
    inline = [
      "echo Citrix123 | sudo -S cat", "sudo iptables -t nat -A PREROUTING -p tcp --dport ${var.app_port}  -d ${var.hostip} -j DNAT --to-destination ${citrixadc_lbvserver.tf_lb.ipv46}:${citrixadc_lbvserver.tf_lb.port}"
]
  connection {
      type        = "ssh"
      host        = "172.16.70.35"
      port        = "22"
      user        = "ctx"
      password    = "Citrix123"
      timeout     = "1m"
   }

}
}


resource "null_resource" "deliptab" {

 triggers = {
    hostip = var.hostip
    app_port = var.app_port
  }
provisioner "remote-exec" {
    when = destroy
    inline = [
      "echo Citrix123 | sudo -S cat", "sudo iptables -t nat -D PREROUTING -p tcp --dport ${self.triggers.app_port}  -d ${self.triggers.hostip} -j DNAT --to-destination 192.0.0.10:80"
]
  connection {
      type        = "ssh"
      host        = "172.16.70.35"
      port        = "22"
      user        = "ctx"
      password    = "Citrix123"
      timeout     = "1m"
   }

}
}
