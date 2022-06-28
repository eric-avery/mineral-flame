module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.name

  min_size                  = var.instance_count
  max_size                  = var.instance_count_max
  desired_capacity          = var.instance_count
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.aws_subnets.public.ids

  # Launch template
  launch_template_name        = "${var.name}-launch-template"
  launch_template_description = "Launch template for mineral-flame"
  update_default_version      = true
  user_data = base64encode(templatefile("${path.module}/userdata.tmpl", {
    tmpl_name            = var.name,
    tmpl_ebs_volume_name = var.ebs_volume_name
    }
    )
  )

  image_id                 = data.aws_ami.amazon-linux-2.image_id
  instance_type            = var.instance_type
  iam_instance_profile_arn = aws_iam_instance_profile.mineral_flame_instance_profile.arn
  ebs_optimized            = true
  enable_monitoring        = true

  network_interfaces = [
    {
      associate_public_ip_address = true
      delete_on_termination       = true
      description                 = "eth0"
      device_index                = 0
      security_groups = [
        module.https_443_security_group.security_group_id,
        module.http_80_security_group.security_group_id,
        module.ssh_security_group.security_group_id
      ]
    }
  ]
}

