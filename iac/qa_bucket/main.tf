
resource "aws_s3_bucket" "qaAppBucket" {
  # force_destroy = true
  bucket        = "${var.env}-sanidhya-pagare-platform-challenge" 
  tags = {
    Name = "${var.env}-sanidhya-pagare-platform-challenge" 
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "appDataCleanup" {
  bucket = aws_s3_bucket.qaAppBucket.id
  rule {
    id     = "data-cleanup"
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_acl" "mytest-app-bucket-acl" {
  bucket = aws_s3_bucket.qaAppBucket.id
  acl    = "private"
}


output "bucket_arn" {
 value       = aws_s3_bucket.qaAppBucket.arn
  description = "S3 bucket ARN"
}
