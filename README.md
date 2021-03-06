DC/OS master remote exec install
============
This module install DC/OS on masters with remote exec via SSH

EXAMPLE
-------

```hcl
module "dcos-masters-install" {
  source  = "terraform-dcos/dcos-install-masters-remote-exec/null"
  version = "~> 0.1.0"

  bootstrap_private_ip = "${module.dcos-infrastructure.bootstrap.private_ip}"
  bootstrap_port       = "80"
  os_user              = "${module.dcos-infrastructure.masters.os_user}"
  dcos_install_mode    = "install"
  dcos_version         = "${var.dcos_version}"
  master_ips           = ["${module.dcos-infrastructure.masters.public_ips}"]
  num_masters          = "3"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bootstrap\_private\_ip | Private IP bootstrap nginx is listening on. Used to build the bootstrap URL. | string | n/a | yes |
| master\_ips | List of masterips to SSH to | list | n/a | yes |
| num\_masters | Specify the amount of masters. For redundancy you should have at least 3 | string | n/a | yes |
| bootstrap\_port | TCP port bootstrap nginx is listening on. Used to build the bootstrap URL. | string | `"80"` | no |
| dcos\_install\_mode | Type of command to execute. Options: install or upgrade | string | `"install"` | no |
| dcos\_skip\_checks | Upgrade option: Used to skip all dcos checks that may block an upgrade if any DC/OS component is unhealthly. (optional) applicable: 1.10+ | string | `"false"` | no |
| dcos\_version | Specifies which DC/OS version instruction to use. Options: 1.13.1, 1.12.3, 1.11.10, etc. See dcos_download_path or dcos_version tree for a full list. | string | `"1.11.3"` | no |
| depends\_on | Modules are missing the depends_on feature. Faking this feature with input and output variables | list | `<list>` | no |
| os\_user | The OS user to be used | string | `"centos"` | no |
| trigger | Triggers for null resource | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| depends | Modules are missing the depends_on feature. Faking this feature with input and output variables |

