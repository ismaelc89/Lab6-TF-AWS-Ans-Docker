output "supported_t3_micro_azs" {
  description = "AZs in this region that support t3.micro"
  value       = data.aws_ec2_instance_type_offerings.t3_micro.locations
}

output "selected_t3_micro_azs" {
  description = "Selected AZs in this region that support t3.micro"
  value       = data.aws_ec2_instance_type_offerings.t3_micro.locations[0]
}

output "instance_public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.public_web.public_ip
}