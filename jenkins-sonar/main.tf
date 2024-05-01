resource "aws_instance" "jenkins" {
  ami = "ami-0287a05f0ef0e9d9a"
  instance_type          = "t2.large"
  key_name               = "sample"
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]
  user_data = templatefile("./install.sh", {})

  tags = {
    Name = "jenkins-sonarqube"
  }

  root_block_device {
    volume_size = 20
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name = "jenkins-vm-sg"
  description = "Allow TLS traffic"
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [{
    description = "Allow all traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "Jenkins-VM-SG"
  }
}
