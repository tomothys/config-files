#region --------- GENERAL 
# Use modern completion system
autoload -Uz compinit
compinit

export EDITOR=nvim
export TERM=screen-256color

# set PATH so it includes user's private bin if it exists 
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# bindkey -v # vi mode

zstyle ':completion:*' menu select

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'o' accept-line

setopt ALWAYS_TO_END
setopt AUTO_PARAM_SLASH
#endregion

#region --------- PROMPT 
setopt prompt_subst

function get_git_branch_name() {
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -z $branch ]]; then
        :
    else
        echo "%F{red}($branch)%f"
    fi
}

function get_node_version() {
    node_version=$(node -v)

    if [[ -z $node_version ]]; then
        :
    else
        echo "%F{green}($node_version)%f"
    fi
}

PROMPT=$'\n%F{blue}%~%f $(get_node_version) $(get_git_branch_name)\n%n %F{yellow}>%f '
#endregion

#region --------- CD PATH 
export CDPATH=$HOME/personal-workspace:$HOME/workspace:$HOME/.config
#endregion

#region --------- NEOVIM
export NVIM_BIN="$HOME/nvim-bins/nvim-0.9.5/bin"
case ":$PATH:" in
  *":$NVIM_BIN:"*) ;;
  *) export PATH="$NVIM_BIN:$PATH" ;;
esac
#endregion

#region --------- VOLTA 
export VOLTA_FEATURE_PNPM=1

case ":$PATH:" in
  *":$HOME/.volta/bin:"*) ;;
  *) export PATH="$HOME/.volta/bin:$PATH" ;;
esac
#endregion

#region --------- PNPM 
export PNPM_HOME="/home/thomasschmieck/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
#endregion

#region --------- FZF 
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS='--height=40% --margin=1 --padding=1 --layout=reverse --border=sharp -i -m --keep-right --filepath-word'
#endregion

#region --------- FUNCTIONS
#------------------------------------------------------------------------------
# better_cd - open up a fuzzy finder to look for a path to change directory to
#------------------------------------------------------------------------------
bcd() {
    cd $(find ${1:-$HOME} -type d -not -name "node_modules" -and -not -name ".git" | fzf)
}
alias better-cd=bcd


#------------------------------------------------
# lf cd - open file explorer to change directory
#------------------------------------------------
lfcd() {
    cd $(lf -print-last-dir ${1:-$HOME})
}


#-------------------------------------------------------------------------------------------------------
# rm_node_modules - find and delete all 'node_modules' folders in current directory and packages folder
#-------------------------------------------------------------------------------------------------------
rmn() {
    local list=$(find ${1:-.} -type d -name "node_modules" -not -path "./node_modules/*" -and -not -path "./submodules/*" | sort -u)

    if [ -z "$list" ]; then
        echo "\e[0;31mNo node_modules found\e[0m"
    else
        echo "DELETING FOLDERS"

        echo "$list" | xargs -I dir sh -c "echo ' \e[0;31m -\e[0m dir'"
        echo "$list" | xargs rm -rf
    fi
}
alias rm-node-modules=rmn

rmi() {
    if test -d ./infrastructure; then
        sudo chmod -R 777 infrastructure && rm -rf infrastructure

        if test -d ./infrastructure; then
            echo '\e[0;31mCould not remove infrastructure folder\e[0m'
        else
            echo '\e[0;31minfrastructure successfully removed\e[0m'
        fi
    else
        echo '\e[0;31minfrastructure directory not found\e[0m'
    fi
}
alias rm-infrastructure=rmi

#--------------------------------------------
# open fuzzy finder to execute docker binary
#--------------------------------------------
dock() {
    local commands="docker compose up
docker compose up --force-recreate --build
docker compose up -d
docker compose up --force-recreate --build -d
docker compose down
docker compose down -v
docker compose watch
docker compose logs -f -t"

    eval "$(echo $commands | fzf)"
}
#-----------------------------------------
# open fuzzy finder to execute git binary
#-----------------------------------------
g() {
    local commands="git status
git pull
git add
git restore
git commit -m
git commit
git restore --staged
git push"

    local chosen_command=$(echo $commands | fzf)

    case $chosen_command in
        *status|*commit|*push|*pull)
            echo $chosen_command
            eval "$chosen_command"
            ;;
        *add)
            echo "git add"
            local chosen_files=$(git diff --name-only | fzf | tr "\n" " ")
            eval "git add $chosen_files && git status"
            ;;
        *restore)
            echo "git restore"
            local chosen_files=$(git diff --name-only | fzf | tr "\n" " ")
            eval "git restore $chosen_files && git status"
            ;;
        *commit*-m)
            echo "git commit -m"
            printf "Commit message: "
            read message
            git commit -m "$message"
            ;;
        *restore*--staged)
            echo "git restore --staged"
            local chosen_files=$(git diff --cached --name-only | fzf | tr "\n" " ")
            eval "git restore --staged $chosen_files && git status"
            ;;
    esac
}
#endregion

#region --------- ALIASES
# general
alias ls="ls --color"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# general aliases
alias q=exit
alias v=nvim
alias open=explorer.exe

# fh - open up a fuzzy finder to search in your command history and execute selected command
# if used in bash replace "fc -l 1" with "history"
alias fh="fc -l 1 | sed 's/ *[0-9]* *//' | sed 's/ *$//' | sort -u | fzf"
alias find-history=fh
#endregion

