# Ansible for Noble Numbat

Just execute `noble.sh`:

```bash
./noble.sh
```

`gnome-extensions enable switch-keyboard-layout@ansible` aftes reboot

For run without `noble.sh`, execute `export python_major_version="3.13" && export ANSIBLE_PYTHON_INTERPRETER=${PYENV_VIRTUAL_ENV}/bin/python3` and then `ansible-playbook noble.yml -K`
