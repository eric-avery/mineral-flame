variable "name" {
  type    = string
  default = "mineral-flame"
}

variable "instance_count" {
  type    = number
  default = 3
}

variable "instance_count_max" {
  type    = number
  default = 6
}

variable "spot_instance_type" {
  type    = string
  default = "one-time"
}

variable "instance_interruption_behavior" {
  type    = string
  default = "terminate"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "domain_name" {
  type    = string
  default = null
}

variable "ebs_volume_name" {
  type    = string
  default = "root"
}