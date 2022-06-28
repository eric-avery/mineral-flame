module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.name

  min_size                  = var.instance_count
  max_size                  = var.instance_count_max
  desired_capacity          = var.instance_count
  key_name                  = aws_key_pair.kp.name
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.aws_subnets.public.ids

  # Launch template
  launch_template_name        = "${var.name}-launch-template"
  launch_template_description = "Launch template for mineral-flame"
  update_default_version      = true
  user_data = base64encode(templatefile("${path.module}/userdata.tmpl", {
    tmpl_name            = var.name
    }
    )
  )

  image_id                 = data.aws_ami.amazon-linux-2.image_id
  instance_type            = var.instance_type
  iam_instance_profile_arn = aws_iam_instance_profile.mineral_flame_instance_profile.arn
  ebs_optimized            = false
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

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = false
        volume_size           = 10
        volume_type           = "gp2"
      }
    }
  ]
}

//pull from param store with more time
resource "aws_key_pair" "kp" {
  key_name   = "kp-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6DYgu/0aUhhlcqfsiRz0XzltppTxwHpJq8wg+Jnblk5GoffRQoJhVwYak+Uu9F/+L9tomemDVkQte3CsFG9kHdw7UEh2dd4W45zzra+J/E73Lyfi54k+1UtRN2H0vh8rm73rWIeSI+1X5vm7NSzJ8GQKmJat6suh/Vh5lJvXvi87sq+Tvj5QrOgzppIAJqe1Xf7CQuQpU3xxrXyyfuW0LgAcaiQFX2wO3CfXugMEqreCXz6Ri8Nu8dOCPoLQD4Fqp/TAlACtoo2KClPFi30E5XlLdxz0Zymb4fwR2UrRHCSB+SemQJW/2l2yjdPV6LTwu3PJ0lSpjuY+LiMmlpACAArhuB3/Aj6svltF79So+4r8TRrZWc3agwHRnJS39zIDu+zpffX348Rf0T9Kas/+kcvqLTyu0zES5AqssOo33TGyVflK1v5H4O194pwPx9JW9IpmK8X53mPrKiUaNe+KS6QDQwJqAAM7iOUJS+kOupg1S0kjfsumnBx2XSLVBWi7dcE9A6mFyPHNiqKgZZzw3V6YNalSgA2Y9swB3Amspy5TJtGK4sIECQhMvAMN1L8WnzmmKmjJv3ym2L4iTlqWAjXNTKFppJd+N1+5XkY/r6LWu/b0Qkh94dLi9yRNOoXHYek3RkBbtwz73f4VvM9P7P7glF0Cv6KtYz5ko92TwDQ== mcken@DESKTOP-N74P745"
}

