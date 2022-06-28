resource "aws_lb" "mineral_flame_alb" {
   name = "${var.name}-alb"
    internal = false
    load_balancer_type = "application"
    subnets = sort(tolist(data.aws_subnets.public.ids))
    security_groups = [
        aws_security_group.mineral_flame_alb_sg.id
    ]
    ip_address_type = "ipv4"
    access_logs {
        enabled = false
       bucket = ""
       prefix = ""
    }
    idle_timeout = "60"
    enable_deletion_protection = "false"
    enable_http2 = "true"
}

resource "aws_lb_listener" "mineral_flame_listener" {
    load_balancer_arn = aws_lb.mineral_flame_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.mineral_flame_tg.arn
        type = "forward"
    }
}

resource "aws_lb_target_group" "mineral_flame_tg" {
    health_check {
        interval = 30
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 5
        matcher = "200"
    }
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = data.aws_vpc.mineral-flame-vpc.id
    name = "mineral-flame-tg"
}

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
