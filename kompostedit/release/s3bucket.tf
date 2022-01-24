//https://barneyparker.com/posts/uploading-file-trees-to-s3-with-terraform/


data "aws_s3_bucket" "kompostapp" {
  bucket = "repo.kompo.st"
}

resource "aws_s3_bucket_object" "content" {
  for_each = fileset("${path.module}/content", "**/*.*")
  bucket       = data.aws_s3_bucket.kompostapp.id
  key          = each.key
  source       = "${path.module}/content/${each.key}"
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  etag         = filemd5("${path.module}/content/${each.key}")
}

locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/vnd.microsoft.icon"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/json"
    "png"  = "image/png"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
  }
}

/*
resource "aws_s3_bucket_object" "single_file" {
  bucket       = data.aws_s3_bucket.selected.id
  key          = "aDir/index.html"
  source       = "app.kompo.st.tf_"
} */

# Create a bucket
/*
resource "aws_s3_bucket" "myBucket" {
  bucket = "repo.kompo.st"
  acl    = "private"   # or can be "public-read"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
} */