if test -d .linuxbrew
  .linuxbrew/bin/brew shellenv | source
end

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -x (brew --prefix)"/bin/starship"
    starship init fish | source
end

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - fish | source

status --is-interactive; and pyenv virtualenv-init - | source
