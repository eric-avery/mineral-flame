module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~>2.14"

  acl = "private"

  bucket = "${var.name}-${var.bucket_name}"

  acceleration_status = "Suspended"

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

    lifecycle_rule = [
    {
      id      = "images"
      enabled = true

      filter = {
        prefix = "Images/"
      }

      transition = [
        {
          days          = 90
          storage_class = "Glacier"
        }
      ]
    },
    {
      id      = "logs"
      enabled = true

      filter = {
        prefix = "Logs/"
      }

      expiration = {
        days = 90
        expired_object_delete_marker = true
      }
    }
    ]
}
