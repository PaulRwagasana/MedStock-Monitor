# Terraform Networking for MedStock Monitor

This folder contains a starter Terraform configuration for the networking layer of the MedStock Monitor project.

## What it creates

- An Azure resource group
- A virtual network with a custom address space
- One application subnet
- A network security group with inbound rules for SSH, HTTP, HTTPS, and the application port
- Outputs for the key networking values

## Prerequisites

- Terraform >= 1.5
- An Azure account
- Azure CLI signed in to your account

## Usage

1. Change into this directory:

   ```bash
   cd terraform
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review the planned resources:

   ```bash
   terraform plan -var="resource_group_name=rg-medstock-dev" -var="location=eastus"
   ```

4. Apply the configuration:

   ```bash
   terraform apply -var="resource_group_name=rg-medstock-dev" -var="location=eastus"
   ```

## Notes

- Replace the example values with your own environment-specific settings.
- The default source IP for ingress is set to `0.0.0.0/0` for simplicity; in production, this should be restricted to your own IP range.
