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

  instance_market_options = {
    market_type = "spot"
    spot_options = {
      instance_interruption_behavior = var.instance_interruption_behavior
      spot_instance_type             = var.spot_instance_type
      max_price                      = "0.1"
    }
  }

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
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]

  schedules = {
    nightly_scale_down = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "30 03 * * *" # Every night at 10:30pm CT/ 3:30am UTC
    }
  }

  tag_specifications = [
    {
      resource_type = "volume"
      tags          = { Name = "${var.name}-root-volume" }
    },
    {
      resource_type = "volume"
      tags          = merge({ Billing = title(var.name) })
    },
        {
      resource_type = "volume"
      tags          = merge({ ProvisionedBy = "Terraform" })
    },
        {
      resource_type = "volume"
      tags          = merge({ Owner = "EAvery" })
    },
        {
      resource_type = "volume"
      tags          = merge({ Project = title(var.name) })
    }
  ]
}

