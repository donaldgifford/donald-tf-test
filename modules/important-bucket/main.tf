#--------------------------------------------------------------
# bucket and  bucket logs bucket
#--------------------------------------------------------------

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.prefix}${var.delimiter}${var.bucket_name}"

  tags = {
    Name = "${var.prefix}${var.delimiter}${var.bucket_name}"
  }
}

resource "aws_s3_bucket" "bucket_logs" {
  bucket = "${var.prefix}${var.delimiter}${var.bucket_name}${var.delimiter}logs"

  tags = {
    Name = "${var.prefix}${var.delimiter}${var.bucket_name}${var.delimiter}logs"
  }
}

#--------------------------------------------------------------
# sse configuration
#--------------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_logs" {
  bucket = aws_s3_bucket.bucket_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#--------------------------------------------------------------
# ownership controls and ACL
#--------------------------------------------------------------


resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_logs" {
  bucket = aws_s3_bucket.bucket_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "bucket_logs" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_logs]
  bucket     = aws_s3_bucket.bucket_logs.id
  acl        = "log-delivery-write"
}

resource "aws_s3_bucket_acl" "bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket]
  bucket     = aws_s3_bucket.bucket.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

#--------------------------------------------------------------
# logging configuration
#--------------------------------------------------------------

resource "aws_s3_bucket_logging" "bucket_logs" {
  bucket        = aws_s3_bucket.bucket.id
  target_bucket = aws_s3_bucket.bucket_logs.id
  target_prefix = "log/"
}

#--------------------------------------------------------------
# bucket metrics
#--------------------------------------------------------------

resource "aws_s3_bucket_metric" "bucket_metrics" {
  bucket = aws_s3_bucket.bucket.id
  name   = "EntireBucket"
}
