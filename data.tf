data "azuredevops_group" "admin" {
  project_id = azuredevops_project.project.id
  name       = "[kplearnsaz]\\Project Collection Administrators"
}