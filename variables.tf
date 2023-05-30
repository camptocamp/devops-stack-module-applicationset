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
  default     = "v1.2.4" # x-release-please-version
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

variable "project_dest_namespace" {
  description = "Allowed destination namespace in the AppProject."
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
    https_insecure = bool
  })
  default = {
    username       = null
    password       = null
    https_insecure = false
  }
}

variable "source_credentials_ssh_key" {
  description = "Credentials to connect to a private repository. Use this variable when connecting to a repository through SSH."
  type        = string
  default     = null
}
