# Terraform Networking for MedStock Monitor

This folder contains a Docker-based Terraform configuration for the networking layer of the MedStock Monitor project.

## What it creates

- A Docker network shared by the application services
- A PostgreSQL container for the database
- A backend container for the application
- Port mappings so the services are reachable from the host machine
- Outputs for the main container and network values

## Prerequisites

- Terraform >= 1.5
- Docker Engine or Docker Desktop running locally

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
   terraform plan
   ```

4. Apply the configuration:

   ```bash
   terraform apply
   ```

5. Check the running containers:

   ```bash
   docker ps
   docker network ls
   ```

## Notes

- The default database credentials are simple example values and should be changed for a real deployment.
- The backend image is expected to be available locally or buildable through Docker before applying the configuration.
