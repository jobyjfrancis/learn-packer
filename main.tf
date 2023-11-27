resource "aws_instance" "joby-test-packer-ec2-minimal" {
    ami = "ami-058b85750531150c5"
    availability_zone = "ap-southeast-2a"
    subnet_id = "subnet-278b2850"
    instance_type = "t3.small"
    key_name = "joby-test"
    associate_public_ip_address = "true"
    vpc_security_group_ids = ["sg-0eb002715df2350c6"]
    tags = {
        Name = "joby-test-packer-ec2-minimal"
    }
}

resource "aws_instance" "joby-test-packer-ec2-full" {
    ami = "ami-050952496bfec195e"
    availability_zone = "ap-southeast-2a"
    subnet_id = "subnet-278b2850"
    instance_type = "t3.small"
    key_name = "joby-test"
    associate_public_ip_address = "true"
    vpc_security_group_ids = ["sg-0eb002715df2350c6"]
    tags = {
        Name = "joby-test-packer-ec2-full"
    }
}