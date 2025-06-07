#!/bin/bash

# Usage:
#   ./bootstrap-push-initial.sh [repo_name] [profile] [tag]
# Defaults:
#   profile = default
#   tag = initial

REPO_NAME=${1}
PROFILE=${2:-default}
TAG=${3:-initial}
AWS_REGION="eu-central-1"

# Get AWS account ID using specified profile
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile "$PROFILE")

# Full ECR repo URI
ECR_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME"

echo "Building Docker image for $REPO_NAME:$TAG"
docker build --platform linux/amd64 -t $REPO_NAME .

echo "Tagging image as $ECR_URI:$TAG"
docker tag $REPO_NAME $ECR_URI:$TAG

echo "Logging in to ECR with profile $PROFILE..."
aws ecr get-login-password --region $AWS_REGION --profile "$PROFILE" \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Pushing image to ECR..."
docker push $ECR_URI:$TAG

echo "✅ Pushed: $ECR_URI:$TAG"
