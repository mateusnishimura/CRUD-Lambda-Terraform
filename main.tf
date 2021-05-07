provider "aws" {
   region = "us-east-1"
}

resource "aws_dynamodb_table" "ddbtable" {
  name             = "FUNCIONARIOS22"
  hash_key         = "funcionario_id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  attribute {
    name = "funcionario_id"
    type = "S"
  }
}

# Policy
resource "aws_iam_role_policy" "create_policy" {
  name = "create_policy"
  role = aws_iam_role.role.id

  policy = file("./policy/create_policy.json")
}

resource "aws_iam_role_policy" "read_policy" {
  name = "read_policy"
  role = aws_iam_role.role.id

  policy = file("./policy/read_policy.json")
}

resource "aws_iam_role_policy" "update_policy" {
  name = "update_policy"
  role = aws_iam_role.role.id

  policy = file("./policy/update_policy.json")
}

resource "aws_iam_role_policy" "delete_policy" {
  name = "delete_policy"
  role = aws_iam_role.role.id

  policy = file("./policy/delete_policy.json")
}

# Role

resource "aws_iam_role" "role" {
  name = "role"

  assume_role_policy = file("./policy/assume_role_policy.json")
}

# Funções

resource "aws_lambda_function" "create" {

  function_name = "create"
  s3_bucket     = "bucketdaton"
  s3_key        = "create.zip"
  role          = aws_iam_role.role.arn
  handler       = "create.handler"
  runtime       = "nodejs12.x"
}


resource "aws_lambda_function" "read" {

  function_name = "read"
  s3_bucket     = "bucketdaton"
  s3_key        = "read.zip"
  role          = aws_iam_role.role.arn
  handler       = "read.handler"
  runtime       = "nodejs12.x"
}

resource "aws_lambda_function" "delete" {

  function_name = "delete"
  s3_bucket     = "bucketdaton"
  s3_key        = "delete.zip"
  role          = aws_iam_role.role.arn
  handler       = "delete.handler"
  runtime       = "nodejs12.x"
}

resource "aws_lambda_function" "update" {

  function_name = "update"
  s3_bucket     = "bucketdaton"
  s3_key        = "update.zip"
  role          = aws_iam_role.role.arn
  handler       = "update.handler"
  runtime       = "nodejs12.x"
}



resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "TonAPI"
}

### POST METHOD
resource "aws_api_gateway_resource" "writeResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "postdb"

}
resource "aws_api_gateway_method" "writeMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.writeResource.id
   http_method   = "POST"
   authorization = "NONE"
}

### GET METHOD
resource "aws_api_gateway_resource" "readResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "getdb"

}
resource "aws_api_gateway_method" "readMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.readResource.id
   http_method   = "GET"
   authorization = "NONE"
}

### PUT METHOD
resource "aws_api_gateway_resource" "updateResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "putdb"

}
resource "aws_api_gateway_method" "updateMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.updateResource.id
   http_method   = "PUT"
   authorization = "NONE"
}

### DELETE METHOD
resource "aws_api_gateway_resource" "deleteResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "deldb"

}
resource "aws_api_gateway_method" "deleteMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.deleteResource.id
   http_method   = "DELETE"
   authorization = "NONE"
}


### INTEGRATION
resource "aws_api_gateway_integration" "writeInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.writeResource.id
   http_method = aws_api_gateway_method.writeMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.create.invoke_arn
   
}

resource "aws_api_gateway_integration" "readInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.readResource.id
   http_method = aws_api_gateway_method.readMethod.http_method

   integration_http_method = "GET"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.read.invoke_arn

}

resource "aws_api_gateway_integration" "updateInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.updateResource.id
   http_method = aws_api_gateway_method.updateMethod.http_method

   integration_http_method = "PUT"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.update.invoke_arn

}

resource "aws_api_gateway_integration" "deleteInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.deleteResource.id
   http_method = aws_api_gateway_method.deleteMethod.http_method

   integration_http_method = "DELETE"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.delete.invoke_arn

}



resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [ aws_api_gateway_integration.writeInt, aws_api_gateway_integration.readInt]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "Prod"
}


resource "aws_lambda_permission" "writePermission" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.create.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/Prod/POST/writedb"

}


resource "aws_lambda_permission" "readPermission" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.read.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/Prod/GET/readdb"

}

resource "aws_lambda_permission" "updatePermission" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.update.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/Prod/PUT/putdb"

}

resource "aws_lambda_permission" "deletePermission" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.delete.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/Prod/DELETE/deldb"

}


output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}