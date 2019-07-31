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

```hcl
data "terraform_remote_state" "rg" {
  backend = "remote"

  config = {
    organization = "<ORG_NAME>"

    workspaces = {
      name = "<WORKSPACE_NAME>"
    }
  }
}

data "terraform_remote_state" "lb" {
  backend = "remote"

  config = {
    organization = "<ORG_NAME>"

    workspaces = {
      name = "<WORKSPACE_NAME>"
    }
  }
}

module "instance" {
  source              = "app.terraform.io/<ORG_NAME>/instance/azurerm"
  version             = "1.0.0"
  tf_az_name          = "demo"
  tf_az_env           = "dev"
  tf_az_location      = "westeurope"
  tf_az_nb_instance   = "2"
  tf_az_prefix        = "web"
  tf_az_instance_type = "Standard_DS1_V2"
  tf_az_subnet_id     = "${data.terraform_remote_state.rg.outputs.subnets_id[0]}"
  tf_az_net_name      = "${data.terraform_remote_state.rg.outputs.virtual_network_name}"
  tf_az_rg_name       = "${data.terraform_remote_state.rg.outputs.resource_group_name}"
  tf_az_lb_bckpool_id = "${data.terraform_remote_state.lb.outputs.load_balancer_backend_pool_id}"

  tf_az_tags          = {"env":"dev","owner":"me"}
}
```

## Authors

* **Nicolas Ehrman** - *Initial work* - [Hashicorp](https://www.hashicorp.com)



