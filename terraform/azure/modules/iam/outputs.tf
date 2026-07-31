output "ci_principal_id" {
  description = "CI/CD service principal object ID used for role assignments (empty when not configured)."
  value       = var.ci_principal_id
}

output "ci_acr_push_role_assignment_id" {
  description = "ID of the AcrPush role assignment for the CI/CD service principal."
  value       = try(azurerm_role_assignment.ci_acr_push[0].id, null)
}

output "ci_rg_reader_role_assignment_id" {
  description = "ID of the Reader role assignment for the CI/CD service principal on the resource group."
  value       = try(azurerm_role_assignment.ci_rg_reader[0].id, null)
}
