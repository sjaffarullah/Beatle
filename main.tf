#S3 bucket
resource "aws_s3_bucket" "music_covers" {
  bucket = var.bucket_name

  tags = {
    Name        = "Beatle Music Covers"
    Environment = "Development"
  }
}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "music_covers_versioning" {
  bucket = aws_s3_bucket.music_covers.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "music_covers_encryption" {
  bucket = aws_s3_bucket.music_covers.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#DynamoDB
resource "aws_dynamodb_table" "music_metadata" {
  name         = "MusicMetadata"
  hash_key     = "trackId" # Primary Key

  attribute {
    name = "trackId"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"

  tags = {
    Name        = "Beatle Music Metadata"
    Environment = "Development"
  }
}


