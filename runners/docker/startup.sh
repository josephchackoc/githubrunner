#!/bin/bash -l

test -n "$GHPATTOKEN" || (echo "GHTOKEN must be set" && false)
test -n "$GHREPO" || (echo "GHREPO must be set" && false)
RUNNERLABEL=${RUNNERLABEL:-myrunner1}

regToken=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GHPATTOKEN" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/${GHREPO}/actions/runners/registration-token | jq -r '.token')

$HOME/actions-runner/config.sh --unattended --url https://github.com/${GHREPO} --token $regToken --labels $RUNNERLABEL

$HOME/actions-runner/run.sh

# Cleanup after runner exits
if [ -e $HOME/actions-runner/config.sh ]; then
  cd $HOME/actions-runner
  deregToken=$(curl -L \
              -X POST \
              -H "Accept: application/vnd.github+json" \
              -H "Authorization: Bearer $GHPATTOKEN" \
              -H "X-GitHub-Api-Version: 2026-03-10" \
              https://api.github.com/repos/${GHREPO}/actions/runners/registration-token | jq -r '.token')
  ./config.sh remove --unattended --token "$deregToken"
fi
