module "mysql_sg" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/haripriyagodishala/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "mysql"
    vpc_id = local.vpc_id
    #vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_tags = var.mysql_sg_tags
}

module "backend_sg" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/haripriyagodishala/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "backend"
    vpc_id = local.vpc_id
    #vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_tags = var.backend_sg_tags
}

module "frontend_sg" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/haripriyagodishala/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "frontend"
    vpc_id = local.vpc_id
    #vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_tags = var.frontend_sg_tags
}

module "bastion_sg" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/haripriyagodishala/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"
    vpc_id = local.vpc_id
    #vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_tags = var.bastion_sg_tags
}

module "ansible_sg" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/haripriyagodishala/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "ansible"
    vpc_id = local.vpc_id
    #vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_tags = var.ansible_sg_tags
}

#mysql allowing connection on 3306 from the instances attached to Backend SG
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306 #mysql port
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.backend_sg.id
  security_group_id = module.mysql_sg.id
}

#backend allowing connection on 8080 from the instances attached to Frontend SG
resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080 #backend nodejs port
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id       = module.frontend_sg.id
  security_group_id = module.backend_sg.id
}

#frontend allowing connection on 80 from the public cidr block
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80 #backend nodejs port
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #all traffic
  security_group_id = module.frontend_sg.id
}

#mysql allowing connection on 22 from bastion server
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.id
  security_group_id = module.mysql_sg.id
}

#backend allowing connection on 22 from the bastion server
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.id
  security_group_id = module.backend_sg.id
}

#frontend allowing connection on 22 from the bastion server
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.id
  security_group_id = module.frontend_sg.id
}

#mysql allowing connection on 22 from ansible server
resource "aws_security_group_rule" "mysql_ansible" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.ansible_sg.id
  security_group_id = module.mysql_sg.id
}

#backend allowing connection on 22 from the ansible server
resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.ansible_sg.id
  security_group_id = module.backend_sg.id
}

#frontend allowing connection on 22 from the ansible server
resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.ansible_sg.id
  security_group_id = module.frontend_sg.id
}

#ansible allowing connection on 22 from public
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22 #ssh connection port
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #all traffic
  security_group_id = module.ansible_sg.id
}

#bastion allowing connection on 22 from public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id
}