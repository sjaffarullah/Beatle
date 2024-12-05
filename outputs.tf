# Output S3 Bucket Name
output "s3_bucket_name" {
  value       = aws_s3_bucket.music_covers.id
  description = "Name of the S3 bucket for music covers"
}

# Output DynamoDB Table Name
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.music_metadata.name
  description = "Name of the DynamoDB table for music metadata"
}
