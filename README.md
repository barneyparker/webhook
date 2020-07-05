# Github Webhook

Experimenting with capturing GitHub Webhooks to trigger various activities in AWS

## What Should This Do?

### On `Ping`

When a new `Ping` event arrives the handler should:

- Create a new entry should be created in a DynamoDB table.

This allows someone to add the name of a source pipeline (Ideally an object added in the subjects Pipeline Terraform)

> Note: Subject pipelines should be set to manual trigger - this handler will trigger the relevent pipeline automatically

### On `pull_request` & `open`

- Read the record from DynamoDB and discover the source pipeline
- Generate a name for a cloned pipeline
- Clone the pipeline, modifying the source branch to ensure the new pipeline build this PR

## on `pull_request` & `closed`

- Read the record from DynamoDB and discover the source pipeline
- Generate a name for a cloned pipeline
- Delete the Clone the pipeline


## GitHub Events

The section details GitHub events and how the Lambda Function acts upon them

### Ping

Sent when a webhook is added to a GitHub repository

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `ping` |
| `respoitory.name` | Short Repository Name |
| `respoitory.full_name` | Full Respository Name |
| `hook.config.secret` | Webhook Secret |
| `hook.config.url` | Repository URL |

### Push

Sent when a commit is pushed to a repository

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `push` |
| `ref` | Git Ref e.g. `refs/heads/master` |
| `pusher.name` | Committers Name |
| `pusher.email` | Committers Email Address |
| `head_commit.id` | Head commit for this push |
| *`created` | `true` on branch creation |
| *`deleted` | `true` on branch deletion |
| *`forced` | `true` on force push |

### Create
Sent when a new branch is created (paired with a push when a new branch is pushed)

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `create` |
| `ref` | Git Short Ref e.g. `master` |
| `ref_type` | Type of Git Ref e.g. `branch` |

### Pull Request Open

Sent when a pull request is opened

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `pull_request` |
| `action` | `open` |
| `pull_request.title` | PR Title |
| `pull_request.head.ref` | Git Ref e.g. `blp/webhook` |
| `pull_request.head.repo.url` | repo url |
| `pull_request.head._links` | Links to the PR |

### Pull Request Comment

Sent when a comment is added to a PR

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `issue_comment` |
| `action` | `created` |

### Pull Request Edit

Sent when a PR is modified (i.e. title edit)

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `pull_request` |
| `action` | `edited` |

Other properties as per Pull Request Created

### Pull Request Closed

Sent when a PR is closed (either bu a user, or merged & closed)

| Property | Comment |
|---|---|
| `X-GitHub-Event` | `pull_request` |
| `action` | `closed` |

Note: a Merged PR will be followed by a push to the parent branch