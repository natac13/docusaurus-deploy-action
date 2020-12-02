#!/bin/sh

set -e
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi


mkdir -p ~/.aws
touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

echo "Change directory to Source"
cd ${GITHUB_WORKSPACE}

echo "Install dependencies"
yarn install

echo "Run yarn build"
yarn run build

echo "Copying to S3 website folder"
if [ -z "$INPUT_DELETEFILES" ]; then
  deleteArg=''
else
  deleteArg='--delete'
fi
if [ -z "$INPUT_CACHE_CONTROL" ]; then
  cacheArg=''
else
  cacheArg='--cache-control ${INPUT_CACHE_CONTROL}'
fi
aws s3 sync ${INPUT_FOLDER} s3://${INPUT_BUCKET} --no-progress --region ${INPUT_REGION} --acl ${INPUT_ACL} ${deleteArg}

echo "Invalidating AWS CloudFront CDN Cache if giving distributionId"
if [ -z "$INPUT_DISTRIBUTIONID" ]
then
  echo "No DistributionId found."
else
  echo "Found CloudFront CDN: ${INPUT_DISTRIBUTIONID}"
  aws cloudfront create-invalidation --distribution-id ${INPUT_DISTRIBUTIONID} --paths ${INPUT_INVALIDATEPATH}
  echo "Successful Invalidation! Goodbye! Natac"
fi

echo "Cleaning up things"

rm -rf ~/.aws
