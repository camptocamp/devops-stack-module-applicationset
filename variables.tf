#######################
## Standard variables
#######################

variable "argocd_namespace" {
  description = "Namespace used by Argo CD where the Application and AppProject resources should be created."
  type        = string
  default     = "argocd"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v2.1.1" # x-release-please-version
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)
  default     = {}
}

#######################
## Module variables
#######################

variable "name" {
  description = "Name to give the AppProject and ApplicationSet (tecnically there is also an Application where the ApplicationSet will reside that will get the same name)."
  type        = string
}

variable "generators" {
  description = "ApplicationSet generators."
  type        = any
}

variable "template" {
  description = "ApplicationSet template."
  type        = any
}

variable "project_appset_dest_cluster_name" {
  description = "Allowed destination cluster *name* in the AppProject. *This is the cluster where the ApplicationSets will reside and could be different than the destination cluster of the ApplicationSet template.*"
  type        = string
  default     = "in-cluster"
}

variable "project_appset_dest_cluster_address" {
  description = "Allowed destination cluster *address* in the AppProject. *This is the cluster where the ApplicationSets will reside and could be different than the destination cluster of the ApplicationSet template.* If you define this variable, any value passed in the `project_appset_dest_cluster_name` variable is ignored."
  type        = string
  default     = null
}

variable "project_dest_cluster_name" {
  description = "Allowed destination cluster *name* in the AppProject. *Must be the same as the the one configured in the ApplicationSet template.*"
  type        = string
  default     = "in-cluster"
}

variable "project_dest_cluster_address" {
  description = "Allowed destination cluster *address* in the AppProject. *Must be the same as the the one configured in the ApplicationSet template.* If you define this variable, any value passed in the `project_dest_cluster_name` variable is ignored."
  type        = string
  default     = null
}

variable "project_dest_namespace" {
  description = "Allowed destination namespace in the AppProject. *Must be the same as the the one configured in the ApplicationSet template.*"
  type        = string
  default     = "*"
}

variable "project_source_repo" {
  description = "Repository allowed to be scraped in this AppProject."
  type        = string
  default     = "*"
}

variable "source_credentials_https" {
  description = "Credentials to connect to a private repository. Use this variable when connecting through HTTPS. You'll need to provide the the `username` and `password` values. If the TLS certificate for the HTTPS connection is not issued by a qualified CA, you can set `https_insecure` as true."
  type = object({
    username       = string
    password       = string
    https_insecure = optional(bool, false)
  })
  default = null
}

variable "source_credentials_ssh_key" {
  description = "Credentials to connect to a private repository. Use this variable when connecting to a repository through SSH."
  type        = string
  default     = null
}
