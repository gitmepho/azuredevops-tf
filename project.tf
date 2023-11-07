resource "azuredevops_project" "project" {
  name = "KP Project"
  #   principal       = data.azuredevops_group.admin.id
  description     = "Test Project for utilizing terraform"
  visibility      = "private"
  version_control = "Git"
}

### Project permissions

resource "azuredevops_project_permissions" "project_permission" {
  project_id = azuredevops_project.project.id
  principal  = data.azuredevops_group.admin.id
  permissions = {
    DELETE              = "Deny"
    EDIT_BUILD_STATUS   = "NotSet"
    WORK_ITEM_MOVE      = "Allow"
    DELETE_TEST_RESULTS = "Deny"
  }
}