# AI Powered email auto replies - Extract email function

##### Running local

```bash
npm i -g esbuild
sam build
sam local invoke --event ./events/s3_event_file.json ExtractEmailLambda
```
