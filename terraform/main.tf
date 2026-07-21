# ============================================================
# main.tf
# Member 1 - Networking & Database
# ============================================================

resource "docker_network" "medstock_network" {
  name = var.network_name
}

resource "docker_image" "postgres" {
  name         = "postgres:15"
  keep_locally = true
}

resource "docker_container" "postgres" {
  image   = docker_image.postgres.image_id
  name    = var.postgres_container_name
  restart = "always"

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 5432
    external = var.postgres_port
  }

  networks_advanced {
    name = docker_network.medstock_network.name
  }
}
