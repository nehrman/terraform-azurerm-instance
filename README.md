# Azure Virtual Machine Module

A Terraform module which creates Linux Virtual Machine on Azure with the following characteristics:
- Create Virtual Nic with dynamic private IP Address
- Configure Security Group for HTTP access
- Create an Availabity Set if a load balancer is configured (True by Default)
- Add VMs in the Backend Address Pool of the Load Balancer

## Terraform versions

Support of Terraform 0.12 is not yet implemented.

If you are using Terraform 0.11 you can use versions `v1.*`.

## Usage

VM Creation example: 

### VM without Data Disk 

```hcl
variable "tf_az_net_name" {
  default = "demo-net"
}

variable "tf_az_rg_name" {
  default = "my-tf-resourcegroup"
}

data "azurerm_subnet" "subnet" {
  name = "subnet1"
  virtual_network_name = "${var.tf_az_net_name}"
  resource_group_name  = "${var.tf_az_rg_name}"
}

data "azurerm_lb" "lb" {
  name                = "example-lb"
  resource_group_name = "${var.tf_az_rg_name}"
}

data "azurerm_lb_backend_address_pool" "lb" {
  name            = "demo"
  loadbalancer_id = "${data.azurerm_lb.lb.id}"
}

module "instance" {
  source              = "github.com/nehrman/terraform-azurerm-instance?ref=v1.0.12"
  tf_az_name          = "demo"
  tf_az_env           = "dev"
  tf_az_location      = "westeurope"
  tf_az_nb_instance   = "2"
  tf_az_prefix        = "web"
  tf_az_instance_type = "Standard_DS1_V2"
  tf_az_subnet_id     = "${data.azurerm_subnet.subnet.id}"
  tf_az_net_name      = "${var.tf_az_net_name}"
  tf_az_rg_name       = "${var.tf_az_rg_name }"
  tf_az_lb_bckpool_id = "${data.azurerm_lb_backend_address_pool.lb.id}"

  tf_az_tags          = ["env":"dev","owner":"me"]
}
```

## Authors

* **Nicolas Ehrman** - *Initial work* - [Hashicorp](https://www.hashicorp.com)



