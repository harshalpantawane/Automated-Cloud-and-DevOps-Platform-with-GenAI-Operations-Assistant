resource "aws_ecr_repository" "App_image" {
  name    = var.repository_name
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
  
  image_tag_mutability_exclusion_filter {
    filter = "latest"
    filter_type = "WILDCARD"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = var.repository_name
    Environment = var.env_name
    ManagedBy = "Terraform"
    
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr-repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description = "Expire untagged images older than 14 days"

        selection = {
          tagStatus = "untaggged"
          countType = "sinceImagePushed"
          countUnit = "days"
          countNumber = 14      
        }

        action = {
          type = "expire"
        }
      }   
    ]
  })
}