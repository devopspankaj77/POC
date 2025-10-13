
# main.tf

# Define the resource in your Terraform configuration
resource "azurerm_resource_group" "rg" {
  name     = "poc"
  location = "Australia East"
}

# Use the import block to link it to an existing Azure resource
# import {
#   to = azurerm_resource_group.rg
#   id = "/subscriptions/bfa25a35-e77a-47a6-8d20-5557ab211ef7/resourceGroups/poc"
# }
# terraform import azurerm_resource_group.rg /subscriptions/bfa25a35-e77a-47a6-8d20-5557ab211ef7/resourceGroups/poc
# terraform import azurerm_resource_group.rg /subscriptions/bfa25a35-e77a-47a6-8d20-5557ab211ef7/resourceGroups/poc
# 
resource "azurerm_virtual_network" "vnet" {
  name                = "poc-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
}

resource "azurerm_subnet" "subnet" {
  name                 = "pocsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  
}

resource "azurerm_public_ip" "pip" {
  name                = "poc-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
 
}

resource "azurerm_network_interface" "nic" {
  name                = "poc-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  

  ip_configuration {
    name                          = "pocipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

  resource "azurerm_network_security_group" "nsg" {
    name                = "pocnsg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    depends_on          = [azurerm_virtual_network.vnet] 
  }

  resource "azurerm_network_security_rule" "ssh" {
    name                        = "nsgrule-ssh"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
   resource "azurerm_network_security_rule" "http" {
    name                        = "nsgrule-http"
    priority                    = 110
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }
   resource "azurerm_network_security_rule" "https" {
    name                        = "nsgrule-https"
    priority                    = 120
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = "poc-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  # admin_password      = "adminpassword"
  # disable_password_authentication = false
  
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
   

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


    
}
