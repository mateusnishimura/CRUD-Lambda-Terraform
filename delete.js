const AWS = require('aws-sdk')

const dynamoDb = new AWS.DynamoDB.DocumentClient()

exports.handler = async event => {

  const params = {
    TableName: "FUNCIONARIOS22",
  }


  const { funcionarioId } = event.pathParameters

  try {
    await dynamoDb
      .delete({
        ...params,
        Key: {
          funcionario_id: funcionarioId
        },
        ConditionExpression: 'attribute_exists(funcionario_id)'
      })
      .promise()
 
    return {
      statusCode: 204
    }
  } catch (err) {
    console.log("Error", err);

    let error = err.name ? err.name : "Exception";
    let message = err.message ? err.message : "Unknown error";
    let statusCode = err.statusCode ? err.statusCode : 500;

    if (error == 'ConditionalCheckFailedException') {
      error = 'Funcionário não existe';
      message = `Recurso com o ID ${funcionarioId} não existe e não pode ser atualizado`;
      statusCode = 404;
    }

    return {
      statusCode,
      body: JSON.stringify({
        error,
        message
      }),
    };
  }
}