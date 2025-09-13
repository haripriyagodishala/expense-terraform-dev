module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws" #opensource ec2 module

  name = local.resource_name
  ami = data.aws_ami.joindevops_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id
  create_security_group = false
  
  tags = merge(
    var.common_tags,
    var.bastion_tags,
    {
        Name = local.resource_name
    }
  )
}

# module "bastion" {
#     source = "../../terraform-aws-ec2"
#     #instance_type = "t3.micro"
#     #name = "bastion"
#     ami_id = data.aws_ami.joindevops_ami.id
#     #ami_id = var.ami_id_variable
#     instance_type = "t2.micro"
#     security_grp_ids = [local.bastion_sg_id]
#     subnet_id              = local.public_subnet_id
#     #security_grp_ids = ["sg-0a1404c2947084704"]
# }