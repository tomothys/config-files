#region --------- GENERAL
export EDITOR=nvim
export TERM=screen-256color

#set PATH so it includes user's private bin if it exists 
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#endregion

#region --------- CD PATH
export CDPATH=$HOME/.config:$HOME/personal-workspace:$HOME/workspace
#endregion

#region --------- NEOVIM
export NVIM_BIN="$HOME/nvim-bins/nvim-0.9.5/bin"
case ":$PATH:" in
  *":$NVIM_BIN:"*) ;;
  *) export PATH="$NVIM_BIN:$PATH" ;;
esac
#endregion

#region --------- PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
#endregion

#region --------- VOLTA
export VOLTA_FEATURE_PNPM=1

case ":$PATH:" in
  *":$HOME/.volta/bin:"*) ;;
  *) export PATH="$HOME/.volta/bin:$PATH" ;;
esac
#endregion

#region --------- FZF
eval "$(fzf --bash)"

export FZF_DEFAULT_OPTS='--height=40% --margin=1 --padding=1 --layout=reverse --border=sharp -i -m --keep-right --filepath-word'
#endregion

#region --------- PROMPT
get_git_branch_name() {
    branch="$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')"

    if [ ! -z "$branch" ]; then
        echo -e " \e[0;31m($branch)\e[0m"
    fi
}

get_node_version() {
    node="$(node -v)"

    if [ ! -z "$node" ]; then
        echo -e " \e[0;32m($node)\e[0m"
    fi
}

PS0="\n"
PS1="\n\[\e[0;34m\]\w\$(get_node_version)\$(get_git_branch_name)\n\[\e[0m\]\u \[\e[0;33m\]> \[\e[0m\]"
#endregion

#region --------- FUNCTIONS
#-------------------------------
# fd - cd to selected directory 
# FZF needs to be installed     
#-------------------------------
fd() {
    local dirs=$(find ${1:-.} -type d -not \( -name node_modules \) | fzf)
    cd $dirs
}
alias find-dir=fd


#----------------------------------------------------------------- 
# fh - search in your command history and execute selected command 
# FZF needs to be installed                                        
#----------------------------------------------------------------- 
fh() {
    local hist

    # if used in bash replace "fc -l 1" with "history"
    local search_result=$(history | sed 's/ *[0-9]* *//' | sed 's/ *$//' | sort -u | fzf)

    $search_result
}
alias find-history=fh

#-------------------------------------------------------------------------------------------------------
# rm_node_modules - find and delete all 'node_modules' folders in current directory and packages folder 
#-------------------------------------------------------------------------------------------------------
rmn() {
    local list=$(find ${1:-.} -type d | grep -v submodules | grep -v ^./node_modules/ | grep node_modules$ | sort -u)
    # local list=$(find ${1:-.} -type d | grep -v ^./node_modules/ | grep node_modules$ | sort -u)

    if [ -z "$list" ]; then
        echo -e "\e[0;31mNo node_modules found\e[0m"
    else
        echo "DELETING FOLDERS"

        echo $list | xargs -n 1 echo -e "\e[0;31m -\e[0m"
        echo $list | xargs rm -rf
    fi
}
alias rm-node-modules=rmn
#endregion

#region --------- ALIASES
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias q=exit
alias v=nvim
alias tmux='tmux -2'

alias dwatch="docker compose watch"
alias docker-watch=dwatch

alias dlogs="docker compose logs -f -t"
alias docker-logs=dlogs

alias dup="docker compose up"
alias docker-up=dup

alias dup-f="docker compose up --force-recreate"
alias dup-b="docker compose up --build"
alias dup-f-b="docker compose up --force-recreate --build"
alias dup-b-f="docker compose up --force-recreate --build"

alias ddown="docker compose down"
alias docker-down=ddown
#endregion
