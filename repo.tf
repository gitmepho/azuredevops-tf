resource "azuredevops_git_repository" "kp_repo" {
  project_id = azuredevops_project.project.id
  name       = "Example Empty Git Repository"
  initialization {
    init_type = "Clean"
  }
}