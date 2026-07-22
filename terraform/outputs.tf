output "docker_network_name" {
  description = "The name of the Docker network shared by the MedStock services."
  value       = docker_network.medstock_network.name
}

output "docker_network_id" {
  description = "The ID of the Docker network shared by the MedStock services."
  value       = docker_network.medstock_network.id
}

output "backend_container_name" {
  description = "The name of the backend container."
  value       = docker_container.medstock_backend.name
}

output "backend_container_id" {
  description = "The ID of the backend container."
  value       = docker_container.medstock_backend.id
}

output "backend_url" {
  description = "The URL used to reach the backend service from the host."
  value       = "http://localhost:${var.backend_external_port}"
}

output "postgres_container_name" {
  description = "The name of the PostgreSQL container."
  value       = docker_container.postgres.name
}

output "postgres_container_id" {
  description = "The ID of the PostgreSQL container."
  value       = docker_container.postgres.id
}