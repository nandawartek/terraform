# https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-policy
module "nanda_ecr_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.37.1"

  # we use suffix because policy can't be recreated when it's in use
  name = "nanda-ecr-${random_string.nanda_ecr_policy_suffix.result}"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:*"
        ]
        Resource = [
          module.nanda_ecr.repository_arn
        ]
      },
    ]
  })
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "nanda_ecr_policy_suffix" {
  length  = 4
  special = false
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment
resource "aws_iam_user_policy_attachment" "nanda_ecr_policy" {
  user       = module.projectsprint_iam_account["nanda"].iam_user_name
  policy_arn = module.nanda_ecr_policy.arn
}
