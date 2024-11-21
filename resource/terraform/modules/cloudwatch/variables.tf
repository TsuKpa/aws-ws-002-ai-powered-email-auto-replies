variable "lambda_function_names" {
  type = string
  description = "Comma separated list of lambda function names"
  default = "ExtractEmailFunction, GenerateEmailFunction, SendEmailFunction"
  validation {
    condition = var.lambda_function_names == "" || can(split(",", var.lambda_function_names))
    error_message = "Provide a comma separated list of lambda function names."
  }
}
