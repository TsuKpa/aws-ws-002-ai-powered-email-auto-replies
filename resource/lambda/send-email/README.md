# Send Email Function

##### Running local (require Docker)

```bash
npm i -g esbuild
sam build
sam local invoke --event ./events/sqs-message.json SendEmailLambda
```
