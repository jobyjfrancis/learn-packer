resource "aws_instance" "joby-test-packer-ec2" {
    ami = "ami-0aaa8bd1552549f12"
    availability_zone = "ap-southeast-2a"
    subnet_id = "subnet-278b2850"
    instance_type = "t3.small"
    key_name = "joby-test"
    associate_public_ip_address = "true"
    vpc_security_group_ids = ["sg-0eb002715df2350c6"]
    tags = {
        Name = "joby-test-packer-ec2"
    }
}