#!/usr/bin/env bash

export ANSIBLE_LOG_PATH=./ansible.log

ansible-playbook $@ -i hosts bootstrap.yml
