resource "azuredevops_git_repository" "kp_repo" {
  project_id = azuredevops_project.project.id
  name       = "Example Empty Git Repository"
  initialization {
    init_type = "Clean"
  }
}

######### Repo Permissions

resource "azuredevops_git_permissions" "repo_permission" {
  project_id    = azuredevops_project.project.id
  repository_id = azuredevops_git_repository.kp_repo.id
  principal     = data.azuredevops_group.admin.id
  permissions = {
    CreateRepository = "Allow"
    DeleteRepository = "Allow"
    RenameRepository = "Allow"
  }
}

######## Branch Permissions

resource "azuredevops_git_permissions" "branch_permissions" {
  project_id    = azuredevops_project.project.id
  repository_id = azuredevops_git_repository.kp_repo.id
  branch_name   = "refs/heads/main"
  principal     = data.azuredevops_group.admin.id
  permissions = {
    RemoveOtherLocks = "Allow"
    ForcePush        = "Allow"
  }
}

######## Branch Policies

resource "azuredevops_branch_policy_auto_reviewers" "auto_reviewers" {
  project_id = azuredevops_project.project.id

  blocking = true
  enabled  = true

  settings {
    auto_reviewer_ids  = [data.azuredevops_group.admin.id]
    submitter_can_vote = false
    message            = "Review Required"


    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = azuredevops_git_repository.kp_repo.default_branch
      match_type     = "Exact"
    }
  }

}

resource "azuredevops_build_definition" "build_def" {
  project_id = azuredevops_project.project.id
  name       = "example build definition"

  repository {
    repo_type = "TfsGit"
    repo_id   = azuredevops_git_repository.kp_repo.id
    yml_path  = "azure-pipeline.yaml"
  }
}

resource "azuredevops_branch_policy_build_validation" "build_validation" {
  project_id = azuredevops_project.project.id

  blocking = true
  enabled  = true

  settings {
    display_name        = "Example build validation policy"
    build_definition_id = azuredevops_build_definition.build_def.id

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = azuredevops_git_repository.kp_repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }

  }

}

resource "azuredevops_branch_policy_comment_resolution" "example" {
  project_id = azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = azuredevops_git_repository.kp_repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_merge_types" "example" {
  project_id = azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {
    allow_squash                  = true
    allow_rebase_and_fast_forward = true
    allow_basic_no_fast_forward   = true
    allow_rebase_with_merge       = true

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = azuredevops_git_repository.kp_repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = null # All repositories in the project
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_min_reviewers" "min_reviewers" {
  project_id = azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count                         = 7
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true # OR on_push_reset_all_votes = true
    on_last_iteration_require_vote         = false

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = azuredevops_git_repository.kp_repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = null # All repositories in the project
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_work_item_linking" "work_item" {
  project_id = azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = azuredevops_git_repository.kp_repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = azuredevops_git_repository.kp_repo.id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}