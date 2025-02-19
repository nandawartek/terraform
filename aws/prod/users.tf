resource "random_string" "password" {
  length  = 33
  special = false
}

variable "projectsprint_teams" {
  type = map(object({
    ec2_instances     = optional(list(string), []) # t2.nano, t2.micro, t4g.small, t4g.medium, t4g.large, t4g.xlarge
    ec2_load_balancer = optional(bool, false)
    db_type           = optional(string, "") # standard, gp2
    db_disk           = optional(string, "")
    db_instances      = optional(list(string), []) # t4g.micro, t4g.small, t4g.medium, t4g.large, t4g.xlarge
    allow_view_ec2    = optional(bool, false)
    allow_create_ec2  = optional(bool, false)
    allow_internet    = optional(bool, false)
  }))

  default = {
    "nanda" = {
      allow_view_ec2 = true
    }
    "example" = {
      allow_view_ec2 = true
    }
    # === Microservice teams === #
    "tries-di" = {
      allow_view_ec2 = true
    }
    "ngikut" = {
      allow_view_ec2 = true
    }
    "6-letters" = {
      allow_view_ec2 = true
    }
    "sigma-skibidi-dev" = {
      allow_view_ec2 = true
    }
    "nano-nano" = {
      allow_view_ec2 = true
    }
    "debug" = {
      allow_view_ec2 = true
    }
    "malu-malu-tapi-suhu" = {
      allow_view_ec2 = true
    }
    "mikroserpis-01" = {
      allow_view_ec2 = true
    }
    "git-gud" = {
      allow_view_ec2 = true
    }


    # === Monolith teams === #
    "bebas-aja" = {
      allow_view_ec2 = true
    }
    "scriptward" = {
      allow_view_ec2 = true
    }
    "semoga-survive" = {
      allow_view_ec2 = true
    }
    "pengcarry-expo" = {
      allow_view_ec2 = true
    }
    "ldh" = {
      allow_view_ec2 = true
    }
    "kambingcoklat" = {
      allow_view_ec2 = true
    }
    "inosys" = {
      allow_view_ec2 = true
    }
    "gasblar" = {
      allow_view_ec2 = true
    }
    "cakalang-fafa" = {
      allow_view_ec2 = true
    }
    "dev-pelajar" = {
      allow_view_ec2 = true
    }
  }
}
// https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-user#outputs
module "projectsprint_iam_account" {
  for_each = var.projectsprint_teams
  source   = "terraform-aws-modules/iam/aws//modules/iam-user"

  version = "5.33.0"

  name = "projectsprint-${each.key}"

  force_destroy                 = true
  create_iam_user_login_profile = true
  password_length               = 8
  password_reset_required       = false
}


resource "aws_iam_group" "projectsprint_developers" {
  name = "projectsprint-developers"
  path = "/projectsprint_developers/"
}

resource "aws_iam_group_membership" "projectsprint_team" {
  name  = "projectsprint-team"
  users = [for account in module.projectsprint_iam_account : account.iam_user_name]
  group = aws_iam_group.projectsprint_developers.name
}

data "aws_iam_user" "current_user" {
  user_name = "nanda-terraform"
}

data "aws_caller_identity" "current" {}
