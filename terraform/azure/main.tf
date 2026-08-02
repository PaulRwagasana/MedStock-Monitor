resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name_prefix         = var.name_prefix
  tags                = var.tags
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.name_prefix}-db-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.network.vnet_name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "psql-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "bastion" {
  source               = "./modules/bastion"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  name_prefix          = var.name_prefix
  subnet_id            = module.network.public_subnet_id
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key
  vm_size              = "Standard_D2s_v3"
  allowed_ssh_cidrs    = var.allowed_ssh_cidrs
  tags                 = var.tags
}

module "compute" {
  source               = "./modules/compute"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  name_prefix          = var.name_prefix
  subnet_id            = module.network.private_subnet_id
  nsg_id               = module.network.private_nsg_id
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key
  vm_size              = "Standard_D2s_v3"
  tags                 = var.tags
}

module "registry" {
  source              = "./modules/registry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name_prefix         = var.name_prefix
  sku                 = "Basic"
  admin_enabled       = false
  principal_id        = module.compute.identity_principal_id
  enable_acr_pull     = true
  tags                = var.tags
}

module "db" {
  source                 = "./modules/db"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  name_prefix            = var.name_prefix
  subnet_id              = azurerm_subnet.db_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres.id
  administrator_login    = var.db_administrator_login
  administrator_password = var.db_administrator_password
  tags                   = var.tags
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "${var.name_prefix}.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_link" {
  name                  = "${var.name_prefix}-postgres-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = module.network.vnet_id
}
