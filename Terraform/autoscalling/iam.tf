resource "aws_iam_role" "be_inst_role" {
  name = "${var.env_name}-s3-cw-rds-ssm-access"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

}

resource "aws_iam_role" "fe_inst_role" {
  name = "${var.env_name}-s3-cw-rds-ssm-access-fe"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name = "${var.env_name}-s3-access-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  roles = [aws_iam_role.be_inst_role.name, aws_iam_role.fe_inst_role.name]
}

resource "aws_iam_policy_attachment" "cloudwatch_agent" {
  name = "${var.env_name}-cw-agent-policy"
  policy_arn = "arn:aws:iam::aws:policy/CloudwatchAgentServerPolicy"
  roles = [aws_iam_role.be_inst_role.name]
}

resource "aws_iam_policy_attachment" "ssm_agent" {
  name = "${var.env_name}-ssm-agent-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagerInstanceCore"
  roles = [aws_iam_role.be_inst_role.name, aws_iam_role.fe_inst_role.name]
}

resource "aws_im_policy_attachment" "rds_access" {
  name = "${var.env_name}-rds-access-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  roles = [aws_iam_role.be_inst_role.name] 
}