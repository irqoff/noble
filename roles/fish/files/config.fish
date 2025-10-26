if test -d .linuxbrew
  .linuxbrew/bin/brew shellenv | source
end

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -x (brew --prefix)"/bin/starship"
    starship init fish | source
end

if test -x (brew --prefix)"/bin/fzf"
    fzf --fish | source
    bind ctrl-alt-f fzf-file-widget
    bind -M insert ctrl-alt-f fzf-file-widget
    set -x FZF_CTRL_T_OPTS "--walker-skip .git --preview 'bat -n --color=always {}' --style minimal --bind 'ctrl-/:change-preview-window(down|hidden|)'"
    set -x FZF_CTRL_R_OPTS "--bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -i -target primary)+abort'"
    set -x FZF_ALT_C_OPTS " --walker-skip .git --style minimal --preview 'tree -C {}'"
end

if test -x (brew --prefix)"/bin/go"
    set -x GOPATH "$HOME/go"
    set -x GOROOT "$(brew --prefix golang)/libexec"
    fish_add_path $HOME/go/bin
end

if test -x (brew --prefix)"/bin/kubectl"
    kubectl completion fish | source
end

if test -x (brew --prefix)"/bin/minikube"
    minikube completion fish | source
end

if test -x (brew --prefix)"/bin/kubectl-krew"
    fish_add_path $HOME/.krew/bin
end

if test -x (brew --prefix)"/bin/nelm"
     nelm completion fish | sed 's/NELM_ACTIVE_HELP=0 //' | source
end

if test -r $HOME/.rca.crt
    set -x NODE_EXTRA_CA_CERTS $HOME/.rca.crt
end

if test -x $HOME/.pyenv
    set -x PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    pyenv init - fish | source
    status --is-interactive; and pyenv virtualenv-init - | source
end

abbr k kubectl
abbr tp tput reset
abbr v nvim
abbr vi nvim
abbr vim nvim
abbr z zellij attach -c main

set -x EDITOR nvim

function fish_greeting
    neofetch
end
