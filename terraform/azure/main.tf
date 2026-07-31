module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  name_prefix         = var.name_prefix
  tags = {
    environment = var.environment
  }
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = var.resource_group_name
  location            = var.location
  name_prefix         = var.name_prefix
  subnet_id           = module.network.public_subnet_id
  admin_ssh_public_key = var.admin_ssh_public_key
  allowed_ssh_cidrs    = var.allowed_ssh_cidrs
  tags = {
    environment = var.environment
  }
}

module "db" {
  source               = "./modules/db"
  resource_group_name  = var.resource_group_name
  location             = var.location
  name_prefix          = var.name_prefix
  administrator_password = var.db_administrator_password
  subnet_id            = module.network.private_subnet_id
  tags = {
    environment = var.environment
  }
}

module "registry" {
  source              = "./modules/registry"
  resource_group_name = var.resource_group_name
  location            = var.location
  name_prefix         = var.name_prefix
  admin_enabled       = var.acr_admin_enabled
  principal_id        = module.compute.identity_principal_id
  tags = {
    environment = var.environment
  }
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  name_prefix         = var.name_prefix
  subnet_id           = module.network.private_subnet_id
  nsg_id              = module.network.private_nsg_id
  admin_ssh_public_key = var.admin_ssh_public_key
  tags = {
    environment = var.environment
  }
}
