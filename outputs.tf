output "websiteendpoint" {
  value = aws_s3_bucket.alicemay2024.website_endpoint
}

output "public_ip" {
  value = aws_instance.eric_devops.public_ip
}
