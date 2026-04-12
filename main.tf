terraform {
    backend "s3" {
        bucket = "sourabh-terraform-state-2026"
        key = "cicd-project/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
    }
}

provider "aws"{
    region = "ap-south-1"
}

resource "aws_security_group" "app_sg"{
    name ="app-server-sg"
    description = "Allow Web and SSH traffic"

   ingress {
         from_port = 80
         to_port = 80
         protocol ="tcp"
         cidr_blocks =["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol ="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


    resource "aws_instance""app_server"{
            ami = "ami-0dee22c13ea7a9a67"
            instance_type = "t3.micro"
            key_name ="serverskey"
            vpc_security_group_ids = [aws_security_group.app_sg.id]

            user_data = <<-EOF
            #!/bin/bash
            sudo apt-get update -y
            sudo apt-get install -y docker.io
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker Ubuntu
            EOF

            tags = {
             Name ="sourabh-app-server"
        }
        }

        output "app_server_ip"{
            value =aws_instance.app_server.public_ip
            }
