variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "mysql_tags" {
    default = {
        Component = "mysql"
    }
}

variable "ansible_tags" {
    default = {
        Component = "ansible"
    }
}

variable "zone_name" {
    default = "haridevops.space"
}
