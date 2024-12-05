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

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_beatle"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policies to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_logs_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Lambda Function Definition
resource "aws_lambda_function" "get_tracks" {
  function_name = "GetTracks"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.9"

  filename         = "lambda_function.zip" # this zip contains lambda function codes
  source_code_hash = filebase64sha256("lambda_function.zip") 
}


