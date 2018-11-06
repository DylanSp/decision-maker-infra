#!/bin/bash

set -ex

sudo pip install awscli --upgrade

stack_name="decision-maker-infra"

if [[ "$TRAVIS_EVENT_TYPE" == "pull_request" ]]; then
    # create changeset
    aws cloudformation create-change-set --stack-name "$stack_name" \
    --template-body file://infrastructure.yml \
    --parameters \
        "ParameterKey=DBRootPassword,ParameterValue=$DB_ROOT_PASS" \
        "ParameterKey=DomainCertARN,ParameterValue=$DOMAIN_CERT_ARN" \
        "ParameterKey=LambdaBucket,ParameterValue=$LAMBDA_BUCKET" \
    --capabilities CAPABILITY_IAM \
    --change-set-name "decision-maker-changeset-$TRAVIS_PULL_REQUEST_SHA"

    # create comment on PR
    api_url="https://api.github.com/repos/DylanSp/decision-maker-infra/issues/$TRAVIS_PULL_REQUEST/comments"
    comment_text="PR contains infrastructure changes; review change set before merge!"

    curl -X POST "$api_url" \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"body\": \"$comment_text\"}"
elif [[ "$TRAVIS_EVENT_TYPE" == "push" ]]; then
    num_parents=$(git cat-file -p "$(git rev-parse HEAD)" | grep -c parent)

    # by definition, if there's more than 1 parent, commit is a merge commit
    if [[ "$num_parents" -gt 1 ]]; then
        merge_commit=$(git rev-parse HEAD^2)    # HEAD^2 will be the merge commit's parent from the branch being merged in
        aws cloudformation execute-change-set --stack-name "$stack_name" \
        --change-set-name "decision-maker-changeset-$merge_commit"
    fi
fi
