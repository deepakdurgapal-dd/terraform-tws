variable "ami" {
  type        = string
  description = "The size of the EC2 instance"
  default     = "ami-01a00762f46d584a1"
}

variable "env" {
  type        = string
  description = "The environment for the EC2 instance"
  default     = "dev"
}

variable "default_root_volume_size" {
  type        = number
  description = "The size of the root volume for the EC2 instance"
  default     = 8
}
