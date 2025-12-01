# ECR Repository for Node.js Microservice
resource "aws_ecr_repository" "nodejs_microservice" {
  name                 = "nodejs-microservice"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(var.tags, {
    Name = "nodejs-microservice"
  })
}

# ECR Lifecycle Policy to keep only the latest image
resource "aws_ecr_lifecycle_policy" "nodejs_microservice" {
  repository = aws_ecr_repository.nodejs_microservice.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

