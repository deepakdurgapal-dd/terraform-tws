# output "ec2_public_ip" {
#   value =  aws_instance.my-tf-ec2.public_ip
# }

# output "ec2_public_dns" {
#   value =  aws_instance.my-tf-ec2.public_dns
# }


# output "ec2_private_ip" {
#   value =  aws_instance.my-tf-ec2.private_ip
# }

# output "vpc_id" {
#   value = aws_default_vpc.default.id
# }

output "ec2_public_ip" {
  value = { for instance in aws_instance.my-tf-ec2 : instance.id => instance.public_ip }
}

output "ec2_private_ip" {
  value = { for instance in aws_instance.my-tf-ec2 : instance.id => instance.private_ip }
}
