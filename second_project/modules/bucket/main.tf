resource "aws_s3_bucket" "first_bucket"{
  bucket = "bucket-test-sw-2026"
  tags = { Name = "EC2-Free-Tier" }
}