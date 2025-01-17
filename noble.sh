#!/bin/bash

set -o errexit -o nounset -o xtrace

source ~/noble/ansible.sh

cd ~/noble && ansible-playbook noble.yml -K --skip-tags linuxbrew_packages

set +o nounset
source "${HOME}/.bashrc_${USER}"
set -o nounset

ansible-playbook noble.yml -t linuxbrew_packages

set +o errexit +o nounset +o xtrace
