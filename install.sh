#!/usr/bin/env bash
# shellcheck disable=SC2068,SC1090

set -o errexit
set -o pipefail
set -o nounset

export ANSIBLE_LOG_PATH=./ansible.log

echo "Bootstrapping local environment..."

ansible-playbook $@ -Ki hosts bootstrap.yml

source "$HOME/.bashrc"

echo "Installing common tooling..."

ansible-playbook $@ -i hosts tools.yml
