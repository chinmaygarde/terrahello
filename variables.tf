variable "admin_user" {
  description = "The default admin user name."
  type = string
  default = "buzzy"
  sensitive = false
}

variable "admin_pubkey" {
  description = "The SSH public key of the admin user name."
  type = string
  sensitive = false
}
