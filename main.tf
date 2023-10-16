resource "null_resource" "dependencies" {
  triggers = var.dependency_ids
}

resource "argocd_repository" "private_https_repo" {
  count = (var.source_credentials_https != null && startswith(var.project_source_repo, "https://")) ? 1 : 0

  repo     = var.project_source_repo
  username = var.source_credentials_https.username
  password = var.source_credentials_https.password
  insecure = var.source_credentials_https.https_insecure
}

resource "argocd_repository" "private_ssh_repo" {
  count = (var.source_credentials_ssh_key != null && startswith(var.project_source_repo, "git@")) ? 1 : 0

  repo            = var.project_source_repo
  username        = "git"
  ssh_private_key = var.source_credentials_ssh_key
}

resource "argocd_project" "this" {
  metadata {
    name      = var.name
    namespace = var.argocd_namespace
  }

  spec {
    description = "${var.name} application project"

    # Concatenate the ApplicationSet repository with the allowed repositories in order to allow the ApplicationSet
    # to be created in this project.
    source_repos = concat(
      [var.project_source_repo],
      ["https://github.com/camptocamp/devops-stack-module-applicationset.git"]
    )

    # The destination block does not support having both `name` and `server` defined at the same time. For that reason,
    # we added the ternary operator below to test if the user provided a `project_dest_cluster_address` variable.
    destination {
      name      = var.project_dest_cluster_address == null ? var.project_dest_cluster_name : null
      server    = var.project_dest_cluster_address == null ? null : var.project_dest_cluster_address
      namespace = var.project_dest_namespace
    }

    # The destination block below is needed in order to allow the ApplicationSet below to be created in the namespace
    # `argocd` while belonging to this project. This block is only needed if the user provides a namespace above
    # instead of the wildcard "*" configured by default AND/OR if the destination cluster of the applications is 
    # different from where the ApplicationSet will reside.
    destination {
      name      = var.project_appset_dest_cluster_address == null ? var.project_appset_dest_cluster_name : null
      server    = var.project_appset_dest_cluster_address == null ? null : var.project_appset_dest_cluster_address
      namespace = var.argocd_namespace
    }

    orphaned_resources {
      warn = true
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_application" "this" {
  metadata {
    name      = var.name
    namespace = var.argocd_namespace
  }

  timeouts {
    create = "15m"
    delete = "15m"
  }

  wait = var.app_autosync == { "allow_empty" = tobool(null), "prune" = tobool(null), "self_heal" = tobool(null) } ? false : true

  spec {
    project = argocd_project.this.metadata.0.name

    source {
      repo_url        = "https://github.com/camptocamp/devops-stack-module-applicationset.git"
      path            = "charts/applicationset"
      target_revision = var.target_revision
      helm {
        value_files = ["values.yaml"]

        parameter {
          name  = "template"
          value = yamlencode(var.template)
        }

        parameter {
          name  = "generators"
          value = yamlencode(var.generators)
        }

        parameter {
          name  = "name"
          value = var.name
        }
      }
    }

    destination {
      name      = var.project_appset_dest_cluster_address == null ? var.project_appset_dest_cluster_name : null
      server    = var.project_appset_dest_cluster_address == null ? null : var.project_appset_dest_cluster_address
      namespace = var.argocd_namespace
    }

    sync_policy {
      dynamic "automated" {
        for_each = toset(var.app_autosync == { "allow_empty" = tobool(null), "prune" = tobool(null), "self_heal" = tobool(null) } ? [] : [var.app_autosync])
        content {
          prune       = automated.value.prune
          self_heal   = automated.value.self_heal
          allow_empty = automated.value.allow_empty
        }
      }

      retry {
        backoff {
          duration     = "20s"
          max_duration = "2m"
          factor       = "2"
        }
        limit = "5"
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }

  depends_on = [
    resource.null_resource.dependencies,
  ]
}

resource "null_resource" "this" {
  depends_on = [
    resource.argocd_application.this,
  ]
}
