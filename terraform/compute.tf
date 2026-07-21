# =============================================================
# compute.tf
# Compute & Security — Cletus (Formative 3, Part 1)
#
# Scope: docker_image + docker_container for the backend ONLY.
#
# What is NOT in this file (owned by teammates):
#   - terraform {} block          → versions.tf  (Member 1)
#   - provider "docker" {}        → versions.tf  (Member 1)
#   - docker_network resource     → main.tf       (Member 1)
#   - postgres image + container  → main.tf       (Member 1)
#   - outputs.tf                  → outputs.tf    (Member 3)
#   - variables.tf                → variables.tf  (Member 1)
#
# All var.* references below are defined in variables.tf by
# Member 1 — no new variables are introduced here.
# =============================================================

# -------------------------------------------------------------
# Pull the application image from GitHub Container Registry.
#
# The CI pipeline (.github/workflows/ci.yml) builds and pushes
# this image on every push using the :ci tag.
#
# keep_locally = true — terraform destroy removes the container
# but leaves the image cached on the local Docker daemon,
# avoiding a slow re-pull on the next terraform apply.
# -------------------------------------------------------------
resource "docker_image" "medstock_app" {
  name         = "ghcr.io/cletusaabugre/medstock-monitor:ci"
  keep_locally = true
}

# -------------------------------------------------------------
# Backend application container
#
# Security measures applied here:
#   - Only the application port (5000) is published to the host.
#     No database port or any other port is exposed externally.
#   - The container is attached to the isolated medstock-network
#     created by Member 1, keeping it separate from unrelated
#     containers on the default Docker bridge.
#   - The non-root 'node' user is enforced in the Dockerfile;
#     Terraform inherits this — no privileged flag is set here.
#   - restart = "always" ensures availability without granting
#     any additional Linux capabilities.
#   - depends_on ensures postgres is running before the backend
#     starts, preventing connection errors on first boot.
# -------------------------------------------------------------
resource "docker_container" "medstock_backend" {
  # Use the image pulled above, referenced by its resolved ID.
  image = docker_image.medstock_app.image_id

  # Container name — reuses the variable defined by Member 1
  # so naming stays consistent across the whole configuration.
  name = var.backend_container_name

  # Restart automatically if the container exits unexpectedly.
  # Mirrors "restart: always" in docker-compose.yml.
  restart = "always"

  # ----------------------------------------------------------
  # Port mapping
  # internal = the port Express listens on inside the container
  #            (matches EXPOSE 5000 in the Dockerfile)
  # external = the port exposed on the host machine
  # Both values come from Member 1's variables.tf so they stay
  # in sync with the rest of the configuration.
  # ----------------------------------------------------------
  ports {
    internal = var.backend_internal_port
    external = var.backend_external_port
  }

  # ----------------------------------------------------------
  # Network
  # Attach to the dedicated bridge network owned by Member 1.
  # Referencing the resource directly (same Terraform state)
  # creates an implicit dependency — Terraform will always
  # create the network before this container.
  # ----------------------------------------------------------
  networks_advanced {
    name = docker_network.medstock_network.name
  }

  # ----------------------------------------------------------
  # Environment variables
  # These match the environment block in docker-compose.yml and
  # are read by backend/src/config/db.js via process.env.
  # DB_HOST uses the postgres container name so the backend
  # resolves it via Docker's internal DNS on medstock-network.
  # ----------------------------------------------------------
  env = [
    "PORT=${var.backend_internal_port}",
    "DB_HOST=${var.postgres_container_name}",
    "DB_PORT=5432",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
  ]

  # ----------------------------------------------------------
  # Ensure the postgres container is running before the backend
  # starts, so the database connection succeeds on first boot.
  # ----------------------------------------------------------
  depends_on = [docker_container.postgres]
}
