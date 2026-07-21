# Ansible Configuration

This directory contains the Ansible configuration used to prepare the MedStock Monitor server after the infrastructure has been provisioned.

The playbook automates the server setup by installing the required software, applying basic security settings, and deploying the MedStock Monitor application together with its PostgreSQL database using Docker.

## Directory Structure

```
ansible/
├── ansible.cfg
├── group_vars/
│   └── all.yml
├── inventory.ini
├── requirements.yml
├── site.yml
└── README.md
```

## Prerequisites

Before running the playbook, ensure you have:

- Ansible installed
- Docker available on the target machine (or allow the playbook to install it)
- Access to the target server through SSH (if using a remote server)
- Terraform provisioning completed (if applicable)

If any Ansible collections are required, install them first:

```bash
ansible-galaxy install -r requirements.yml
```

## Inventory

The default inventory file is:

```text
inventory.ini
```

It currently targets:

```ini
[medstock]
localhost ansible_connection=local
```

If you want to deploy to a remote server, replace `localhost` with your server's IP address or hostname and update the connection details accordingly.

## Running the Playbook

Run the playbook using:

```bash
ansible-playbook -i inventory.ini site.yml
```

For a remote server, you can specify the SSH user if needed:

```bash
ansible-playbook -i inventory.ini site.yml -u <username>
```

## What the Playbook Does

The playbook performs the following tasks:

- Updates the package cache.
- Installs the required packages, including Docker, UFW, Fail2Ban and Python Docker support.
- Starts and enables the Docker service.
- Creates the Docker network used by the application.
- Deploys a PostgreSQL database container.
- Deploys the MedStock Monitor application container from GitHub Container Registry.
- Waits for the database and application to become available.
- Configures the firewall to allow SSH and the application port.
- Disables SSH root login.
- Disables SSH password authentication.
- Ensures Fail2Ban is enabled to help protect against brute-force attacks.

## Configuration

Most configuration values are stored in:

```
group_vars/all.yml
```

This includes:

- Application name
- Docker image
- Container ports
- Database configuration
- Allowed firewall ports
- Base packages to install

These values can be modified without changing the playbook itself.

## Notes

- The playbook is designed to be idempotent, so it can be run multiple times without causing duplicate configurations.
- If the application image is updated in GitHub Container Registry, rerunning the playbook will pull the latest image and redeploy the container.
- Check the Ansible output for any errors if the deployment does not complete successfully.
