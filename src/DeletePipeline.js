const GetRepositoryEntry = require('./GetRepositoryEntry')
const aws = require('./aws-clients')

module.exports = DeletePipeline = async (repository, reviewId) => {
  console.log(`Pull Request ${reviewId} Closed in ${repository}`)

  // Get our source pipeline name
  const entry = await GetRepositoryEntry(repository)

  console.log('Got Pipeline Entry: ', entry)

  // Check if the entry has the necessary details
  if(entry.Item && entry.Item.pipeline !== 'unknown') {
    console.log(`Deleting Clone Pipeline: ${entry.Item.pipeline.S}-PR-${reviewId}`)
    const result = await aws.codepipeline.deletePipeline({
      name: `${entry.Item.pipeline.S}-PR-${reviewId}`
    }).promise()

    console.log('Clone Pipeline Delete Result: ', result)
  } else {
    console.log('Pipeline Entry Not Configured')
  }
}