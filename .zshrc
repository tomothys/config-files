#region --------- PLUGIN MANAGER
ZINIT_HOME="$HOME/.local/share/zinit/zinit"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"
#endregion

#region --------- PLUGINS
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
#endregion

#region --------- GENERAL 
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

# Use modern completion system
autoload -Uz compinit && compinit

export EDITOR=nvim

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
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

setopt menu_complete

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward
# bindkey -v # vi mode
bindkey -e # emacs mode

# completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)ls_colors}'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'o' accept-line

setopt ALWAYS_TO_END
setopt AUTO_PARAM_SLASH
unsetopt beep
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
export VOLTA_HOME=$HOME/.volta

case ":$PATH:" in
  *":$VOLTA_HOME/bin:"*) ;;
  *) export PATH="$VOLTA_HOME/bin:$PATH" ;;
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


#--------------------------------------------------------------------------------------------
# fh - open up a fuzzy finder to search in your command history and execute selected command
#--------------------------------------------------------------------------------------------
fh() {
    # if used in bash replace "fc -l 1" with "history"
    local command=$(fc -l 1 | sed 's/ *[0-9]* *//' | sed 's/ *$//' | sort -u | fzf)
    eval "$command"
}
alias find-history=fh


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
d() {
    local commands="docker compose up
docker compose up --force-recreate --build
docker compose up -d
docker compose up --force-recreate --build -d
docker compose down
docker compose down -v
docker compose watch
docker compose logs -f -t
docker compose exec ... bash"

    local chosen_command=$(echo $commands | fzf)

    if [[ ! -z "$chosen_command" ]]; then
        case $chosen_command in
        *exec*)
            echo -e "\e[0;32m$chosen_command\e[0m"

            printf "Container Compose Name: "
            read container_name

            echo -e "\e[0;32mdocker compose exec $container_name bash\e[0m"
            docker compose exec $container_name bash
            ;;
        *)
            echo -e "\e[0;32m$chosen_command\e[0m"
            eval "$chosen_command"
            ;;
	esac
    fi
}
alias dock-fuzzy=d


#-----------------------------------------
# open fuzzy finder to execute git binary
#-----------------------------------------
g() {
    local commands="git status
git pull
git pull --recurse-submodule
git add
git restore
git commit -m
git commit
git restore --staged
git push
git clone --recurse-submodule"

    local chosen_command=$(echo $commands | fzf)

    case $chosen_command in
        *add)
            echo -e "\e[0;32m$chosen_command\e[0m"
            local chosen_files=$(git diff --name-only | fzf | tr "\n" " ")
            eval "git add $chosen_files && git status"
            ;;
        *restore)
            echo -e "\e[0;32m$chosen_command\e[0m"
            local chosen_files=$(git diff --name-only | fzf | tr "\n" " ")
            eval "git restore $chosen_files && git status"
            ;;
        *commit*-m)
            echo -e "\e[0;32m$chosen_command\e[0m"
            printf "Commit message: "
            read message
            git commit -m "$message"
            ;;
        *restore*--staged)
            echo -e "\e[0;32m$chosen_command\e[0m"
            echo "git restore --staged"
            local chosen_files=$(git diff --cached --name-only | fzf | tr "\n" " ")
            eval "git restore --staged $chosen_files && git status"
            ;;
        *close*)
            echo -e "\e[0;32m$chosen_command\e[0m"
            printf "Repository URL: "
            read url
            printf "Path: "
            read path
            git clone --recurse-submodule $url $path
            ;;
        *)
            echo -e "\e[0;32m$chosen_command\e[0m"
            eval "$chosen_command"
            ;;
    esac
}
alias git-fuzzy=g

#---------------------------------------------------
# open fuzzy finder to execute package.json scripts
#---------------------------------------------------
p() {
    if [[ ! -f package.json ]]; then
        echo -e "\e[0;31mpackage.json not found\e[0m"
    elif [ $(jq 'has("scripts")' package.json) = false ]; then
        echo -e "\e[0;31m'scripts' required\e[0m"
    else
        local chosen_script=$(jq '.scripts | keys' package.json | grep '"' | tr -d ' ,"' | fzf)

        if [[ ! -z "$chosen_script" ]]; then
            echo -e "\e[5m\e[0;32m$chosen_script\e[0m\e[25m"

            eval "pnpm $chosen_script"
        fi
    fi
}
alias pnpm-fuzzy=p
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
#endregion

