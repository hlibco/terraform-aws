resource "aws_iam_server_certificate" "www" {
  name            = "www"
  private_key     = "${var.private_key}"
  certificate_body = "${var.certificate_body}"
}

resource "aws_iam_role" "default" {
  name               = "default-role-${var.environment}"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "default" {
  name   = "default-role-policy-${var.environment}"
  role   = "${aws_iam_role.default.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1425916919000",
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:Get*",
                "cloudwatch:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "default" {
  name = "default-${var.environment}"
  role = "${aws_iam_role.default.name}"

  lifecycle {
    create_before_destroy = true
  }
}

