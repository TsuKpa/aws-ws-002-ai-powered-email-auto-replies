# AI Powered email auto replies - Extract email function

##### Running local

```bash
# Build
npm i -g esbuild
sam build

# Invoke local (Optional)
sam local invoke --event ./events/s3_event_file.json ExtractEmailLambda

# Zip before upload to Lambda (manual)
cd .aws-sam/ExtractEmailLambda && zip -r index.zip .
```