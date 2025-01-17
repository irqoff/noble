#!/bin/bash

set -o errexit -o nounset -o xtrace

sudo true

readonly custom_bashrc="${HOME}/.bashrc_${USER}"
readonly python_major_version="3.13"
export python_major_version
readonly venv="ansible"

echo "Installing git"
sudo apt update
sudo apt install -y git

if [[ -d "${HOME}/.pyenv" ]]; then
  cd "${HOME}/.pyenv"
  git pull
  cd
else
  git clone https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"
fi

if [[ ! -f "${custom_bashrc}" ]]; then
  echo -e '\n\n# reading custom .bashrc' >> "${HOME}/.bashrc"
  echo "source ${custom_bashrc}" >> "${HOME}/.bashrc"

  echo '# pyenv_begin' > "${custom_bashrc}"
  echo 'export PYENV_ROOT="${HOME}/.pyenv"' >> "${custom_bashrc}"
  echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"' >> "${custom_bashrc}"
  echo 'eval "$(pyenv init -)"' >> "${custom_bashrc}"
  echo '# pyenv_end' >> "${custom_bashrc}"
fi

echo "Install dependencies"
sudo apt -y install build-essential cargo curl libbz2-dev libffi-dev liblzma-dev\
  libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev\
  libxmlsec1-dev llvm tk-dev

set +o nounset
source "${custom_bashrc}"
set -o nounset

python_version=$(pyenv install -l | grep -E "^  ${python_major_version}\.[0-9]+$" | tail -1 | tr -d ' ')
export python_version

if [[ ! -d "${HOME}/.pyenv/versions/${python_version}" ]]; then
  pyenv install "${python_version}"
fi

if [[ -d "${HOME}/.pyenv/plugins/pyenv-virtualenv" ]]; then
  cd "${HOME}/.pyenv/plugins/pyenv-virtualenv"
  git pull
  cd
else
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
fi

if ! grep -q '# pyenv-virtualenv_begin' "${custom_bashrc}"; then
  echo '# pyenv-virtualenv_begin' >> "${custom_bashrc}"
  echo 'eval "$(pyenv virtualenv-init -)"' >> "${custom_bashrc}"
  echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> "${custom_bashrc}"
  echo '# pyenv-virtualenv_end' >> "${custom_bashrc}"
fi

set +o nounset
source "${custom_bashrc}"
set -o nounset

if [[ ! -d "${HOME}/.pyenv/versions/${python_version}/envs/ansible" ]]; then
  pyenv virtualenv "${python_version}" "${venv}"
fi

set +o nounset
pyenv deactivate || true
pyenv activate "${venv}"
set -o nounset

pip install --upgrade ansible ansible-lint docker pre-commit psutil yamllint
ansible --version
ansible-galaxy collection install -r requirements.yml --force

ANSIBLE_PYTHON_INTERPRETER="$(pyenv root)/versions/${python_version}/envs/ansible/bin/python3"
export ANSIBLE_PYTHON_INTERPRETER

set +o errexit +o nounset +o xtrace
