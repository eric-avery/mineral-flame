

resource "aws_security_group" "mineral_flame_alb_sg" {
    description = "SG for the mineral-flame alb"
    name = "${var.name}-alb-sg"
    
    vpc_id = data.aws_vpc.mineral-flame-vpc.id
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}
