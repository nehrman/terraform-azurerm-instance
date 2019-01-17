variable "tf_az_name" {
  description = "Name used to create all resources except subnets"
}

variable "tf_az_env" {
  description = "Environnement where the resources will be created"
}

variable "tf_az_rg_name" {
  description = "Name of Resource group to which data will be collected"
}

variable "tf_az_tags" {
  description = "The tags to associate with your network and subnets."
  type        = "map"
}

variable "tf_az_nb_instance" {
  description = "Number of instances that will be deployed"
  default     = "1"
}

variable "tf_az_prefix" {
  description = "Prefix used to configure name of VMs. Ex : web"
}

variable "tf_az_location" {
  description = "Define location of Azure DC"
}

variable "tf_az_subnet_id" {
  description = "Define Subnet that will be used for NIC configuration"
}

variable "tf_az_net_name" {
  description = "Define network that will be used for NIC configuration"
}

variable "tf_az_instance_type" {
  description = "Define the type of instace to deplay"
  default     = "Standard_DS1_V2"
}

variable "tf_az_lb_conf" {
  description = "Define if LB is needed or not."
  default     = true
}

variable "tf_az_lb_bckpool_id" {
  type        = "list"
  description = "Define Id of backend pool to connect the virtual network interface too."
  default     = []
}
