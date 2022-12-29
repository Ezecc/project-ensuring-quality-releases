provider "azurerm" {
  features {}
  skip_provider_registration = "true"
  subscription_id = "cb599c66-cf7f-4d26-957f-c657317dbc0b"
}
terraform {
  backend "azurerm" {
    storage_account_name = "tfstate3122530360"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    access_key           = "1bi8DdOmzAuloYZRwT+pXKeZdYuOlHiPnR2xjtB+fCbdvJtbGVkXLj8XAhDP0ayUgkHvPVoiEUNv+AStSZQizA=="
  }
}

data "azurerm_resource_group" "test" {
  name = "tfstate"
}


module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${data.azurerm_resource_group.test.name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${data.azurerm_resource_group.test.name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${data.azurerm_resource_group.test.name}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${data.azurerm_resource_group.test.name}"
}
module "vm" {
  source               = "../../modules/vm"
  location             = "${var.location}"
  resource_group       = "${data.azurerm_resource_group.test.name}"
  subnet_id            = module.network.subnet_id_test
  public_ip_address_id = module.publicip.public_ip_address_id 
  admin_username       = var.admin_username
  prefix               = var.prefix
}