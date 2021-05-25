#!/bin/sh -l

echo "In entrypoint"
echo "USER: $USER"
whoami
echo "PWD: $PWD"
export PATH="$PATH:/root/.local/bin/"
which -a bandit
ls -la /root/.local/bin/bandit
ln -s /root/.local/bin/bandit /bin/bandit
which -a bandit
which -a semgrep
ls -la /
echo "
config_version: 1
active_scanners: $INPUT_ACTIVE_SCANNERS
enforced_scanners: $INPUT_ENFORCED_SCANNERS

custom_info:
  sha1: $GITHUB_SHA
  reponame: $GITHUB_REPOSITORY
  ref: $GITHUB_REF
  ci_username: $GITHUB_ACTOR
  github_action: $GITHUB_ACTION
  github_workflow: $GITHUB_WORKFLOW
  github_event_name: $GITHUB_EVENT_NAME
  github_event_path: $GITHUB_EVENT_PATH
  github_workspace: $GITHUB_WORKSPACE
  github_head_ref: $GITHUB_HEAD_REF
  github_base_ref: $GITHUB_BASE_REF
  github_home: $HOME

reports:
  - uri: $INPUT_REPORT_URI
    format: $INPUT_REPORT_FORMAT
    verbose: $INPUT_REPORT_VERBOSITY" | tee $GITHUB_WORKSPACE/../salus-configuration.yaml 

cd /home && BUNDLE_GEMFILE=/home/Gemfile bundle exec /home/bin/salus scan --repo_path "$GITHUB_WORKSPACE" --config "$SALUS_CONFIGURATION"
