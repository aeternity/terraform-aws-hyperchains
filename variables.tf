variable "vault_addr" {
  description = "Vault server URL address"
}

variable "bootstrap_version" {
  default = "v4.3.0"
}

variable "dns_zone" {
  default = "ZSEEAAX46MKWZ"
}

variable "lb_fqdn_demo" {
  default = "demo.hyperchains.aeternity.io"
}

variable "certificate_arn_demo" {
  default = "arn:aws:acm:eu-north-1:106102538874:certificate/49b2912b-5269-4e00-84ee-cd6f0f2c7627"
}

variable "lb_fqdn_dincho" {
  default = "dincho.hyperchains.aeternity.io"
}

variable "certificate_arn_dincho" {
  default = "arn:aws:acm:eu-north-1:106102538874:certificate/49b2912b-5269-4e00-84ee-cd6f0f2c7627"
}

variable "lb_fqdn_perf" {
  default = "perf.hyperchains.aeternity.io"
}

variable "certificate_arn_perf" {
  default = "arn:aws:acm:eu-north-1:106102538874:certificate/49b2912b-5269-4e00-84ee-cd6f0f2c7627"
}
