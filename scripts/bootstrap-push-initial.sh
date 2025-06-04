#!/bin/bash

# Usage:
#   ./bootstrap-push-initial.sh [profile] [tag]
# Defaults:
#   profile = default
#   tag = initial

PROFILE=${1:-default}
TAG=${2:-initial}
STAGE=${3:-prod}
AWS_REGION="eu-central-1"

# Get AWS account ID using specified profile
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile "$PROFILE")

# Full ECR repo URI
ECR_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$STAGE-django_images"

echo "Building Docker image for $REPO:$TAG"
docker build --platform linux/amd64 -t $REPO .

echo "Tagging image as $ECR_URI:$TAG"
docker tag $REPO $ECR_URI:$TAG

echo "Logging in to ECR with profile $PROFILE..."
aws ecr get-login-password --region $AWS_REGION --profile "$PROFILE" \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Pushing image to ECR..."
docker push $ECR_URI:$TAG

echo "✅ Pushed: $ECR_URI:$TAG"
