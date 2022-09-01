#######################
## Standard variables
#######################

variable "argocd_namespace" {
  type = string
}

#######################
## Module variables
#######################

variable "name" {
  description = "Project and application name where the ApplicationSet will reside"
  type        = string
}

variable "generators" {
  description = "ApplicationSet generators"
  type        = any
}

variable "template" {
  description = "ApplicationSet template"
  type        = any
}

variable "project_dest_namespace" {
  description = "Allowed destination namespace in the AppProject"
  type        = string
  default     = "*"
}

variable "project_source_repos" {
  description = "Allowed repositories in the AppProject"
  type        = list(string)
  default     = ["*"]
}
