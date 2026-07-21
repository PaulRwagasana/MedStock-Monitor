resource "docker_network" "medstock_network" {
  name            = var.network_name
  check_duplicate = true
}

resource "docker_image" "postgres" {
  name         = "${var.postgres_image_name}:${var.postgres_image_tag}"
  keep_locally = false
}

resource "docker_image" "backend" {
  name         = "${var.backend_image_name}:${var.backend_image_tag}"
  keep_locally = false
}

resource "docker_container" "postgres" {
  name    = var.postgres_container_name
  image   = docker_image.postgres.image_id
  restart = "always"

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  networks_advanced {
    name = docker_network.medstock_network.name
  }

  ports {
    internal = 5432
    external = var.postgres_external_port
  }
}

resource "docker_container" "backend" {
  name    = var.backend_container_name
  image   = docker_image.backend.image_id
  restart = "always"

  env = [
    "PORT=${var.backend_internal_port}",
    "DB_HOST=${docker_container.postgres.name}",
    "DB_PORT=5432",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}"
  ]

  networks_advanced {
    name = docker_network.medstock_network.name
  }

  ports {
    internal = var.backend_internal_port
    external = var.backend_external_port
  }

  depends_on = [docker_container.postgres]
}
