const AWS = require('aws-sdk')

const dynamoDb = new AWS.DynamoDB.DocumentClient()

exports.handler = async (event) => {

  const params = {
    TableName: "FUNCIONARIOS22",
  }  

  try {
    let data = await dynamoDb.scan(params).promise();

    return {
      statusCode: 200,
      body: JSON.stringify(data.Items)
    };
  } catch (err) {
    console.log("Error", err);
    return {
      statusCode: err.statusCode ? err.statusCode : 500,
      body: JSON.stringify({
        error: err.name ? err.name : "Exception",
        message: err.message ? err.message : "Unknown error",
      }),
    }
  }
}