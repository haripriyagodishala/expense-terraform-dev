module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws" #opensource ec2 module

  name = "${local.resource_name}-mysql"
  ami = data.aws_ami.joindevops_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,
    {
        Name = "${local.resource_name}-mysql"
    }
  )
}

module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws" #opensource ec2 module

  name = "${local.resource_name}-backend"
  ami = data.aws_ami.joindevops_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,
    {
        Name = "${local.resource_name}-backend"
    }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws" #opensource ec2 module

  name = "${local.resource_name}-frontend"
  ami = data.aws_ami.joindevops_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,
    {
        Name = "${local.resource_name}-frontend"
    }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws" #opensource ec2 module

  name = "${local.resource_name}-ansible"
  ami = data.aws_ami.joindevops_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_id
  user_data = file("expense.sh")

  tags = merge(
    var.common_tags,
    var.ansible_tags,
    {
        Name = "${local.resource_name}-ansible"
    }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  # zone_name = keys(module.zones.route53_zone_zone_id)[0]
  # zone_name = var.zone_name
  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        "10.0.21.83" #private IP of mysql server
        #module.mysql.private_ip
      ]
    },
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        "10.0.11.236" #private IP of backend
      ]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        "10.0.1.51" #private IP of frontend
      ]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        "98.81.109.71" #public IP of frontend
      ]
    }
  ]
}