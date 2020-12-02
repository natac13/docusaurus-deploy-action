#!/bin/sh

set -e

# if [ -z "$AWS_S3_BUCKET" ]; then
#   echo "AWS_S3_BUCKET is not set. Quitting."
#   exit 1
# fi
#
# if [ -z "$AWS_ACCESS_KEY_ID" ]; then
#   echo "AWS_ACCESS_KEY_ID is not set. Quitting."
#   exit 1
# fi
#
# if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
#   echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
#   exit 1
# fi
#
# if [ -z "$AWS_REGION" ]; then
#   echo "AWS_REGION is not set. Quitting."
#   exit 1
# fi
#
# if [ -z "$AWS_STACK_NAME" ]; then
#   echo "AWS_STACK_NAME is not set. Quitting."
#   exit 1
# fi


# mkdir -p ~/.aws
# touch ~/.aws/credentials
#
# echo "[default]
# aws_access_key_id = ${AWS_ACCESS_KEY_ID}
# aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

echo "Change directory to Source"
cd ${GITHUB_WORKSPACE}

# echo "Install dependencies"
# yarn install
#
# echo "Run yarn build"
# yarn run build
#
# echo "Serve test"
# yarn run serve --port 3000

# echo "Copying to website folder"
# aws s3 sync ./build/ s3://${AWS_S3_BUCKET} --exact-timestamps --delete --region ${AWS_REGION}

echo "Invalidating AWS CloudFront CDN Cache for certground.com"
# Get distribution ID
id=$(aws cloudformation describe-stacks --region ${AWS_REGION} --stack-name ${AWS_STACK_NAME} --query "Stacks[0].Outputs[?OutputKey=='DistributionId'].OutputValue" --output text)

if [ -z "$id" ]
then
  echo "No DistributionId found. Meaning there was an error!!"
else
  echo "Found CloudFront CDN: ${id}"
  # aws cloudfront create-invalidation --distribution-id ${id} --paths "/*"
  echo "Successful Invalidation! Goodbye! Natac"
fi
#
# echo "Cleaning up things"
#
# rm -rf ~/.aws
