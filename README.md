# AWS S3 Deploy GitHub Action

### Easily deploy a static website to AWS S3 and invalidate CloudFront distribution

## Usage

You can use this action by referencing the v1 branch

```yaml
uses: natac13/s3-gh-deploy-action@v1
with:
    folder: './build'
    bucket: ${{ secrets.S3_BUCKET }}
    region: 'us-east-1'
    distributionId: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
    invalidatePath: '/*'
    deleteFiles: true
    acl: 'private'
```

## Arguments

S3 Deploy's Action supports inputs from the user listed in the table below:

Input               | Type             | Required | Default      | Description
------------------  | ---------------- | -------- | ------------ | -----------
| `folder`          | string           | Yes      | './build'    | The folder to upload
| `bucket`          | string           | Yes      |              | The destination bucket
| `region`          | string           | Yes      | 'us-east-1'  | The destination bucket region
| `distributionId`  | string           | No       |              | The CloudFront Distribution ID to invalidate
| `invalidationPath`| string           | No       | '/*'         | The CloudFront Distribution path(s) to invalidate
| `deleteFiles`     | boolean          | No       |              | Removes files in S3, that are not available in the local copy of the directory
| `cache_control`   | string           | No       |              | Use this parameter to specify `Cache-Control: no-cache, etc.` header
| `acl`             | string           | No       | 'private'    | Upload files with given ACL


### Example `workflow.yml` with S3 Deploy Action

```yaml
name: Example workflow for S3 Deploy
on: [push]
jobs:
  run:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
        - uses: actions/checkout@v2

        - name: Deploy
          uses: natac13/s3-gh-deploy-action@v1
          with:
            folder: './build'
            bucket: ${{ secrets.S3_BUCKET }}
            region: 'us-east-1'
            distributionId: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
            invalidatePath: '/*'
            deleteFiles: true
            acl: 'private'
```

## License

[MIT License](LICENSE).
