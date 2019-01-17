# Create Network Nic to use with VM
resource "azurerm_network_interface" "vm" {
  count                                    = "${var.tf_az_nb_instance}"
  name                                     = "${var.tf_az_env}-${var.tf_az_prefix}-nic-${count.index}"
  location                                 = "${var.tf_az_location}"
  resource_group_name                      = "${var.tf_az_rg_name}"
  network_security_group_id                = "${azurerm_network_security_group.vm.id}"

  ip_configuration {
    name                                     = "ipconf${count.index}"
    subnet_id                                = "${var.tf_az_subnet_id}"
    private_ip_address_allocation            = "dynamic"
    load_balancer_backend_address_pools_ids  = "${var.tf_az_lb_bckpool_id}"
  }

  tags                                       = "${var.tf_az_tags}"
}

# Create Security Group related to VMs
resource "azurerm_network_security_group" "vm" {
  name                  = "${var.tf_az_env}-${var.tf_az_prefix}-sg"
  location              = "${var.tf_az_location}"
  resource_group_name   = "${var.tf_az_rg_name}"
  tags                  = "${var.tf_az_tags}"

  security_rule {
    name                          = "allow_remote_access_to_vm"
    description                   = "Allow remote protocol in from all locations"
    priority                      = 100
    direction                     = "Inbound"
    access                        = "Allow"
    protocol                      = "Tcp"
    source_port_range             = "*"
    destination_port_range        = "80"
    source_address_prefix         = "*"
    destination_address_prefix    = "*"
  }
}

resource "azurerm_availability_set" "vm" {
  count                        = "${var.tf_az_lb_conf}"
  name                         = "${var.tf_az_env}-${var.tf_az_prefix}-avset"
  location                     = "${var.tf_az_location}"
  resource_group_name          = "${var.tf_az_rg_name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# Create Azure Web Server Instances
resource "azurerm_virtual_machine" "vm" {
  count                  = "${var.tf_az_nb_instance}"
  name                   = "${var.tf_az_env}-${var.tf_az_prefix}-vm-${count.index}"
  location               = "${var.tf_az_location}"
  resource_group_name    = "${var.tf_az_rg_name}"
  network_interface_ids  = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  vm_size                = "${var.tf_az_instance_type}"
  availability_set_id    = "${azurerm_availability_set.vm.id}"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.tf_az_env}-${var.tf_az_prefix}-vm-${count.index}-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.tf_az_prefix}${count.index}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = "${var.tf_az_tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_virtual_machine_extension" "test" {
  count                = "${var.tf_az_nb_instance}"
  name                 = "webserver"
  location             = "${var.tf_az_location}"
  resource_group_name  = "${var.tf_az_rg_name}"
  virtual_machine_name = "${var.tf_az_env}-${var.tf_az_prefix}-vm-${count.index}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  depends_on           = ["azurerm_virtual_machine.vm"]

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/nehrman/terraform-azure-demo/master/modules/azure-instance/user-data.sh"],
        "commandToExecute": "sudo sh user-data.sh"
    }
SETTINGS

  tags = "${var.tf_az_tags}"
}