#!/bin/bash
set -euo pipefail

# USAGE ./bump.sh <BRANCH> <VERSION>
#
# - <BRANCH> is the branch we want to bump the version, e.g. `7.x`, `7.16`, etc.
# - <VERSION> needs to be MAJOR.MINOR.PATCH
# - A github token with enough rights needs to be passed as CLIENTS_GITUB_TOKEN or
#   be available under ~/.elastic/github.token
#

#
# BEGIN SETUP
# Check for required variables
#
script_path=$(dirname $(realpath -s $0))
organization="elastic"
repo='elasticsearch-ruby'

if [[ -z "$1" ]]; then echo "Must provide branch" 1>&2; exit 1; fi
if [[ -z "$2" ]]; then echo "Must provide the new version" 1>&2; exit 1; fi

branch=$1
version=$2

echo "Branch: $1 - Version: $2"

token=${CLIENTS_GITHUB_TOKEN-}
github_user=${CLIENTS_GITHUB_USER-"clients-team"}
if [[ -f ~/.elastic/github.token ]]; then
    token=$(cat ~/.elastic/github.token)
fi
if [ -z "$token" ]; then echo "No github token available"; exit 1; fi
if [ -z "$github_user" ]; then echo "No github user available"; exit 1; fi
#
# END SETUP
#

curl_data()
{
    cat <<EOF
    {
      "title": "Bumps ${branch} to ${version}",
      "maintainer_can_modify": true,
      "head": "${branch_name}",
      "base": "${branch}"
    }
EOF
}

# git checkout $branch
git config --global user.email "fernando.briano@elastic.co"
git config --global user.name "Clients machine"

echo "GITHUB TOKEN: ${token}"

branch_name=bump_${branch}_to_${version}
git remote set-url origin https://${github_user}:${token}@github.com/elastic/elasticsearch-ruby.git

git checkout -b $branch_name
git add .
git commit -m "Bumps to version ${version}"
git push --set-upstream origin $branch_name
curl \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${token}" \
    https://api.github.com/repos/elastic/$repo/pulls \
    -d "$(curl_data)"
