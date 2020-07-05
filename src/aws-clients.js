const DynamoDB = require('aws-sdk/clients/dynamodb')
const CodePipeline = require('aws-sdk/clients/codepipeline')
const SSM = require('aws-sdk/clients/ssm')

module.exports = {
  dynamodb: new DynamoDB({apiVersion: '2012-08-10'}),
  codepipeline: new CodePipeline({apiVersion: '2015-07-09'}),
  ssm: new SSM({apiVersion: '2014-11-06'})
}
