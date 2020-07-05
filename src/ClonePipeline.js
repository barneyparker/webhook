const GetRepositoryEntry = require('./GetRepositoryEntry')
const aws = require('./aws-clients')

module.exports = ClonePipeline = async (repository, reviewId, ref) => {
  console.log(`Pull Request ${reviewId} Opened for ${ref} in ${repository}`)

  // Get our source pipeline name
  const entry = await GetRepositoryEntry(repository)

  console.log('Got Pipeline Entry: ', entry)

  // Check if the entry has the necessary details
  if(entry.Item && entry.Item.pipeline !== 'unknown') {

    // Get the pipeline information
    const parent = await aws.codepipeline.getPipeline({
      name: entry.Item.pipeline.S
    }).promise()

    console.log('Parent Pipline Def: ', parent)

    // Copy the details for a new pipeline
    const clone = {
      pipeline: {
        name: `${parent.pipeline.name}-PR-${reviewId}`,
        roleArn: parent.pipeline.roleArn,
        artifactStore: parent.pipeline.artifactStore,
        stages: parent.pipeline.stages
      },
      tags: parent.pipeline.tags
    }

    // Get the OAuth Token from SSM
    const OAuthToken = await aws.ssm.getParameter({
      Name: entry.Item.OAuthParameter.S,
      WithDecryption: true
    }).promise()

    // Tweak for our branch (and add the missing OAuth Token)
    clone.pipeline.stages[0].actions[0].configuration.OAuthToken = OAuthToken.Parameter.Value
    clone.pipeline.stages[0].actions[0].configuration.Branch = ref
    if(!clone.tags) {
      clone.tags = []
    }
    clone.tags.push({
      key: 'pull_request',
      value: reviewId.toString()
    })

    console.log('Creating Clone Pipeline:', JSON.stringify(clone, null, 2))
    try {
      const result = await aws.codepipeline.createPipeline(clone).promise()
      console.log(result)
    } catch(err) {
      console.log('Create Clone Pipline Error: ', err)
    }


  }
}
