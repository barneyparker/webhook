const ClonePipeline = require('./ClonePipeline')
const DeletePipeline = require('./DeletePipeline')
const TriggerPipeline = require('./TriggerPipeline')

// eslint-disable-next-line immutable/no-mutation
module.exports.handler = async (event) => {

  console.log('Event: ', JSON.stringify(event, null, 2))

  if(!event.headers['X-GitHub-Event'] && !event.headers['x-github-event']) {
    console.log('Missing X-GitHub-Event Header')
    return {
      statusCode: 403,
      headers: {
        'Content-Type': 'text/plain',
      },
      body: 'Forbidden'
    }
  } else {

    let body = ''
    if(event.isBase64Encoded) {
      console.log('Decoding Base64 Body')
      const buff = Buffer.from(event.body, 'base64')
      const bodyText = decodeURIComponent(buff.toString('ascii'))
      body = JSON.parse(bodyText.slice(8))
    } else {
      body = JSON.parse(event.body)
    }

    const githubEvent = event.headers['X-GitHub-Event'] || event.headers['x-github-event']
    const githubAction = body.action || ''

    console.log('Github Event: ', githubEvent)
    console.log('Github Action: ', githubAction)
    console.log('User Agent: ', event.headers['User-Agent'])
    console.log('Body: ', JSON.stringify(body, null, 2))

    
    if(githubEvent === 'pull_request') {
      if(githubAction === 'opened' || githubAction === 'reopened') {
        // PR Opened, create a clone of our parent pipeline with a ref matching the PR
        await ClonePipeline(body.repository.full_name, body.pull_request.number, body.pull_request.head.ref)
      } else if(githubAction === 'closed') {
        // PR Closed, remove this cloned pipeline
        await DeletePipeline(body.repository.full_name, body.pull_request.number)
      } else if(githubAction === 'synchronize') {
        // PR Updated, trigger a new run of the pipeline
        await TriggerPipeline(body.repository.full_name, body.pull_request.number)
      } else {
        // Some other action occurred that we dont handle
        console.log(`Unhandled Pull Request Action: ${githubAction}`)
      }
    } else if(githubEvent === 'push' && body.ref === 'refs/heads/master') {
      // A commit was push to the master branch (or merged from another branch)
      // Trigger the main pipeline
      await TriggerPipeline(body.repository.full_name, null)
    }

    // Always return OK to ensure GitHub is happy
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/plain',
      },
      body: 'OK'
    }
  }
}
