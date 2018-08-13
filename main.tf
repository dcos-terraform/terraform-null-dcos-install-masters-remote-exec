/**
 * DC/OS master remote exec install
 * ============
 * This module install DC/OS on masters with remote exec via SSH
 *
 * EXAMPLE
 * -------
 *
 *```hcl
 * module "dcos-masters-install" {
 *   source  = "terraform-dcos/dcos-install-masters-remote-exec/null"
 *   version = "~> 0.1"
 *
 *   bootstrap_private_ip = "${module.dcos-infrastructure.bootstrap.private_ip}"
 *   bootstrap_port       = "80"
 *   os_user              = "${module.dcos-infrastructure.masters.os_user}"
 *   dcos_install_mode    = "install"
 *   dcos_version         = "${var.dcos_version}"
 *   master_ips           = ["${module.dcos-infrastructure.masters.public_ips}"]
 *   num_masters          = "3"
 * }
 *```
 */

module "dcos-mesos-master" {
  source  = "dcos-terraform/dcos-core/template"
  version = "~> 0.0"

  # source               = "/Users/julferts/git/github.com/fatz/tf_dcos_core"
  bootstrap_private_ip = "${var.bootstrap_private_ip}"
  dcos_bootstrap_port  = "${var.bootstrap_port}"

  # Only allow upgrade and install as installation mode
  dcos_install_mode = "${var.dcos_install_mode}"
  dcos_version      = "${var.dcos_version}"
  role              = "dcos-mesos-master"
}

resource "null_resource" "master" {
  triggers = {
    dependency_id = "${join(",", var.depends_on)}"
  }

  count = "${var.num_masters}"

  connection {
    host = "${element(var.master_ips, count.index)}"
    user = "${var.os_user}"
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/dcos_install.sh); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["module.dcos-mesos-master"]
}
