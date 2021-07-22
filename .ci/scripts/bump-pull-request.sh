#!/bin/bash
set -euo pipefail

# USAGE ./bump.sh <BRANCH> <VERSION>
#
# - <BRANCH> is the branch we want to bump the version, e.g. `7.x`, `7.16`, etc.
# - <VERSION> needs to be MAJOR.MINOR.PATCH
# - A github token with enough rights needs to be passed as CLIENTS_GITUB_TOKEN or
#   be available under ~/.elastic/github.token
#
# Version 1.0.0
# - Initial version

#
# BEGIN SETUP - Check for required variables
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

# Download gh cli
wget -q https://github.com/cli/cli/releases/download/v1.14.0/gh_1.14.0_linux_amd64.tar.gz
tar -zxf gh_1.14.0_linux_amd64.tar.gz
mv gh_1.14.0_linux_amd64/bin/gh /usr/local/bin/
rm gh_1.14.0_linux_amd64 -rf

gh auth login --with-token <<< $token
git config --global user.email "elasticmachine@users.noreply.github.com"
git config --global user.name "Elastic Machine"

branch_name=bump_${branch}_to_${version}
git checkout -b $branch_name
git add .
git commit -m "Bumps to version ${version}"

git push --set-upstream origin $branch_name
gh pr create --title "Bumps ${branch} to ${version}" --base ${branch} --body "As titled"
