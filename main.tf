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
 *   version = "~> 0.1.0"
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
  version = "~> 0.1.0"

  # source               = "/Users/julferts/git/github.com/fatz/tf_dcos_core"
  bootstrap_private_ip = "${var.bootstrap_private_ip}"
  dcos_bootstrap_port  = "${var.bootstrap_port}"

  # Only allow upgrade and install as installation mode
  dcos_install_mode = "${var.dcos_install_mode}"
  dcos_version      = "${var.dcos_version}"
  dcos_skip_checks  = "${var.dcos_skip_checks}"
  role              = "dcos-mesos-master"
}

locals {
  # install_script = "${var.dcos_install_mode == "install" ? "dcos_install.sh" : "dcos_node_upgrade.sh"}"
  install_script = "dcos_install.sh"
}

resource "null_resource" "master1" {
  triggers = {
    trigger = "${join(",", var.trigger)}"
  }

  count = "${var.num_masters >= 1 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 1)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "# depends ${join(",",var.depends_on)}'",
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["module.dcos-mesos-master"]
}

resource "null_resource" "master2" {
  triggers = {
    dependency_id = "${null_resource.master1.id}"
  }

  count = "${var.num_masters >= 2 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 2)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master1"]
}

resource "null_resource" "master3" {
  triggers = {
    dependency_id = "${null_resource.master2.id}"
  }

  count = "${var.num_masters >= 3 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 3)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master2"]
}

resource "null_resource" "master4" {
  triggers = {
    dependency_id = "${null_resource.master3.id}"
  }

  count = "${var.num_masters >= 4 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 4)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master3"]
}

resource "null_resource" "master5" {
  triggers = {
    dependency_id = "${null_resource.master4.id}"
  }

  count = "${var.num_masters >= 5 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 5)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master4"]
}

resource "null_resource" "master6" {
  triggers = {
    dependency_id = "${null_resource.master5.id}"
  }

  count = "${var.num_masters >= 6 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 6)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master5"]
}

resource "null_resource" "master7" {
  triggers = {
    dependency_id = "${null_resource.master6.id}"
  }

  count = "${var.num_masters >= 7 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 7)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master6"]
}

resource "null_resource" "master8" {
  triggers = {
    dependency_id = "${null_resource.master7.id}"
  }

  count = "${var.num_masters >= 8 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 8)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master7"]
}

resource "null_resource" "master9" {
  triggers = {
    dependency_id = "${null_resource.master8.id}"
  }

  count = "${var.num_masters >= 9 ? 1 : 0}"

  connection {
    host = "${element(var.master_ips, 9)}"
    user = "${var.os_user}"
    agent= true
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-master.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/${local.install_script}); do printf 'waiting for bootstrap node (%s:%d) to serve...' '${var.bootstrap_private_ip}' '${var.bootstrap_port}'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["null_resource.master8"]
}
