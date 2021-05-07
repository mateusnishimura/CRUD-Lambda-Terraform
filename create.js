const AWS = require('aws-sdk')

const dynamoDb = new AWS.DynamoDB.DocumentClient()


exports.handler = async (event) => {
  

  const params = {
    TableName: "FUNCIONARIOS22",
  }

    try {
      let dados = JSON.parse(event.body)
  
      const {
        nome, idade, cargo
      } = dados;
  
      const funcionario = {
        funcionario_id: uuidv4(),
        nome,
        idade,
        cargo,
        status: true,
      }
  
      await dynamoDb
        .put({
          TableName: "FUNCIONARIOS22",
          Item: funcionario,
        })
        .promise();
  
      return {
        statusCode: 201
      }
  
    } catch (err) {
      console.log("Error", err);
      return {
        statusCode: err.statusCode ? err.statusCode : 500,
        body: JSON.stringify({
          error: err.name ? err.name : "Exception",
          message: err.message ? err.message : "Unknown error",
        }),
      };
    }
  }