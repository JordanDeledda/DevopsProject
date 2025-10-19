variable "kubeconfig" {
  description = "Chemin vers le kubeconfig local"
  type        = string
}

variable "metallb_address_pool" {
  description = "Plages IP (Layer2) pour MetalLB. Ex: [\"192.168.1.240-192.168.1.250\"]"
  type        = list(string)
}

variable "grafana_admin_password" {
  description = "Mot de passe admin Grafana"
  type        = string
  sensitive   = true
}