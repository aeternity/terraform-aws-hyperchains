###
# Parent chain for demo hyperchain
###

module "nodes_aehc_demo_parent_stockholm" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v4.0.0"
  env               = "aehc_demo"

  static_nodes   = 1
  spot_nodes_min = 0
  spot_nodes_max = 0

  instance_type  = "m5.large"
  instance_types = ["m6i.large", "m5.large"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 20
  additional_storage      = true
  additional_storage_size = 40

  asg_target_groups = module.lb_aehc_demo_parent_stockholm.target_groups

  tags = {
    role  = "aenode"
    env   = "aehc_demo"
    kind  = "parent"
  }

  config_tags = {
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_version = var.bootstrap_version
    bootstrap_config  = "secret2/aenode/config/aehc_demo_parent"
  }

  providers = {
    aws = aws.eu-north-1
  }
}

module "mdw_aehc_demo_parent_stockholm" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v4.0.0"
  env               = "aehc_demo"

  static_nodes   = 1
  spot_nodes_min = 0
  spot_nodes_max = 0

  instance_type  = "t3.large"
  instance_types = ["t3.large", "c5.large", "m5.large"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 20
  additional_storage      = true
  additional_storage_size = 40

  vpc_id  = module.nodes_aehc_demo_parent_stockholm.vpc_id
  subnets = module.nodes_aehc_demo_parent_stockholm.subnets

  enable_mdw = true

  asg_target_groups = module.lb_aehc_demo_parent_stockholm.target_groups_mdw

  tags = {
    role  = "aemdw"
    env   = "aehc_demo"
    kind  = "parent"
  }

  config_tags = {
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_version = var.bootstrap_version
    bootstrap_config  = "secret2/aenode/config/aehc_demo_parent_mdw"
  }

  providers = {
    aws = aws.eu-north-1
  }
}

module "lb_aehc_demo_parent_stockholm" {
  source                    = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v2.0.0"
  env                       = "aehc_demo"
  fqdn                      = var.lb_fqdn_parent
  dns_zone                  = var.dns_zone
  security_group            = module.nodes_aehc_demo_parent_stockholm.sg_id
  mdw_security_group        = module.mdw_aehc_demo_parent_stockholm.sg_id
  vpc_id                    = module.nodes_aehc_demo_parent_stockholm.vpc_id
  subnets                   = module.nodes_aehc_demo_parent_stockholm.subnets

  enable_ssl                = true
  certificate_arn           = var.certificate_arn

  internal_api_enabled      = true
  state_channel_api_enabled = false
  mdw_enabled               = true
  dns_health_check          = false

  providers = {
    aws = aws.eu-north-1
  }
}

###
# Hyperchain aechc_demo
###

module "nodes_aehc_demo_stockholm" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v4.0.0"
  env               = "aehc_demo"

  static_nodes   = 1
  spot_nodes_min = 0
  spot_nodes_max = 0

  instance_type  = "t3.large"
  instance_types = ["t3.large", "c5.large", "m5.large"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 20
  additional_storage      = true
  additional_storage_size = 40

  asg_target_groups = module.lb_aehc_demo_stockholm.target_groups

  tags = {
    role  = "aenode"
    env   = "aehc_demo"
    kind  = "child"
  }

  config_tags = {
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_version = var.bootstrap_version
    bootstrap_config  = "secret2/aenode/config/aehc_demo_validator"
  }

  providers = {
    aws = aws.eu-north-1
  }
}


module "mdw_aehc_demo_stockholm" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v4.0.0"
  env               = "aehc_demo"

  static_nodes   = 1
  spot_nodes_min = 0
  spot_nodes_max = 0

  instance_type  = "t3.large"
  instance_types = ["t3.large", "c5.large", "m5.large"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 20
  additional_storage      = true
  additional_storage_size = 40

  vpc_id  = module.nodes_aehc_demo_stockholm.vpc_id
  subnets = module.nodes_aehc_demo_stockholm.subnets

  enable_mdw = true

  asg_target_groups = module.lb_aehc_demo_stockholm.target_groups_mdw

  tags = {
    role  = "aemdw"
    env   = "aehc_demo"
    kind  = "child"
  }

  config_tags = {
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_version = var.bootstrap_version
    bootstrap_config  = "secret2/aenode/config/aehc_demo_mdw"
  }

  providers = {
    aws = aws.eu-north-1
  }
}

module "lb_aehc_demo_stockholm" {
  source                    = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v2.0.0"
  env                       = "aehc_demo"
  fqdn                      = var.lb_fqdn
  dns_zone                  = var.dns_zone
  security_group            = module.nodes_aehc_demo_stockholm.sg_id
  mdw_security_group        = module.mdw_aehc_demo_stockholm.sg_id
  vpc_id                    = module.nodes_aehc_demo_stockholm.vpc_id
  subnets                   = module.nodes_aehc_demo_stockholm.subnets

  enable_ssl                = true
  certificate_arn           = var.certificate_arn

  internal_api_enabled      = true
  state_channel_api_enabled = false
  mdw_enabled               = true
  dns_health_check          = false

  providers = {
    aws = aws.eu-north-1
  }
}
