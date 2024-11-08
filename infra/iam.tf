resource "aws_iam_role" "glue_role" {
  name = "GlueCrawlerRole"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "glue.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "glue_full_policy" {
  name        = "GlueFullAccessPolicy"
  description = "Full policy for Glue Crawler access including S3 and EC2 actions"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "glue:*",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketAcl",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeRouteTables",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcAttribute",
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "cloudwatch:PutMetricData"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:CreateBucket"
        ],
        "Resource": [
          "arn:aws:s3:::aws-glue-*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::aws-glue-*/*",
          "arn:aws:s3:::*/*aws-glue-*/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject"
        ],
        "Resource": [
          "arn:aws:s3:::crawler-public*",
          "arn:aws:s3:::aws-glue-*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:*:*:/aws-glue/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ],
        "Condition": {
          "ForAllValues:StringEquals": {
            "aws:TagKeys": [
              "aws-glue-service-resource"
            ]
          }
        },
        "Resource": [
          "arn:aws:ec2:*:*:network-interface/*",
          "arn:aws:ec2:*:*:security-group/*",
          "arn:aws:ec2:*:*:instance/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource": "*"
      },
      # Adicionando permissões específicas para o Glue Job
      {
        "Effect": "Allow",
        "Action": [
          "glue:CreateJob",
          "glue:GetJob",
          "glue:GetJobRun",
          "glue:StartJobRun",
          "glue:UpdateJob",
          "glue:DeleteJob",
          "glue:GetTable",
          "glue:BatchGetTable",
          "glue:BatchGetPartition",
          "glue:GetTableVersion",
          "glue:BatchCreatePartition",
          "glue:BatchDeletePartition"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::dev-us-east-1-data-1-project/*",
          "arn:aws:s3:::dev-us-east-1-data-1-project/bronze/iceberg/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "glue:CreateDatabase",
          "glue:UpdateDatabase",
          "glue:GetDatabase",
          "glue:DeleteDatabase"
        ],
        "Resource": [
          "arn:aws:glue:us-east-1:183631349055:catalog",
          "arn:aws:glue:us-east-1:183631349055:database/*",
          "arn:aws:glue:us-east-1:183631349055:table/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_role_attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_full_policy.arn
}
