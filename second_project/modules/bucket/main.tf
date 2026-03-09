resource "aws_s3_bucket" "first_bucket"{
  bucket = "bucketTestSW2026"
  tags = { Name = "EC2-Free-Tier" }
}