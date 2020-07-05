const aws = require('./aws-clients')

module.exports = TriggerPipeline = async(repository, reviewId) => {
  console.log(`Pull Request ${reviewId} Updated in ${repository}`)

    // Get our source pipeline name
    const entry = await GetRepositoryEntry(repository)

    console.log('Got Pipeline Entry: ', entry)
  
    // Check if the entry has the necessary details
    if(entry.Item && entry.Item.pipeline !== 'unknown') {
      let name = ''
      if(reviewId === null) {
        name = entry.Item.pipeline.S
      } else {
        name = `${entry.Item.pipeline.S}-PR-${reviewId}`
      }

      const result = await aws.codepipeline.startPipelineExecution({
        name
      }).promise()

      console.log('Pipeline Execution Result: ', result)
    } else {
      console.log('Pipeline Entry Not Configured')
    }
}