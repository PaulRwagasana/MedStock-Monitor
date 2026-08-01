resource_group_name = "rg-medstock-monitor"
location             = "eastus"
environment          = "production"
name_prefix          = "medstock"

admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9FMIDksdOhxRtjqbaofhT1ZOqc8cjS6KLiyfy3xH/W medstock-deploy"

allowed_ssh_cidrs = ["0.0.0.0/0"]

db_administrator_password = "medstockKey123!"

acr_admin_enabled = false

client_id       = ""
client_secret   = ""
tenant_id       = ""
subscription_id = ""
