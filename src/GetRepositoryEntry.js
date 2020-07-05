const aws = require('./aws-clients')

module.exports = GetRepositoryEntry = async (repository) => {
  return aws.dynamodb.getItem({
    TableName: process.env.repository_table,
    Key: {
      repository: { S: repository }
    }
  }).promise()
}