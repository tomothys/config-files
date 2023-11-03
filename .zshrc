export TERM=tmux-256color

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# pnpm
export PNPM_HOME="/home/thomasschmieck/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# Volta
export VOLTA_HOME="$HOME/.volta"
export MASON_BIN="$HOME/.local/share/nvim/mason/bin"
export PATH="$VOLTA_HOME/bin:$MASON_BIN:$PATH"

# neovim path
export NVIM_BIN="$HOME/nvim_bins/nvim-macos-0.9.4/bin"
export PATH="$NVIM_BIN:$PATH"

export CDPATH="$CDPATH:$HOME/.config:$HOME/Projects"

#-----------------
# Auto-completion
#-----------------
# # Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#-----
# FZF
#-----
export FZF_DEFAULT_OPTS='--height=40% --margin=1 --padding=1 --layout=reverse --border=sharp -i -m --keep-right --filepath-word'

#--------
# PROMPT
#--------
setopt prompt_subst

function git_branch_name() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')

    if [[ $branch == "" ]];
    then
        :
    else
        echo "%F{red} $branch%f"
    fi
}

PROMPT=$'\n%F{blue}%n%f %F{yellow}  %~%f $(git_branch_name)\n > '

#-------------------------------
# fd - cd to selected directory
# FZF needs to be installed
#-------------------------------
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -not \( -name node_modules -prune \) -print 2> /dev/null | fzf +m) && cd "$dir"
}

#------------------------------------------------------------------
# fh - search in your command history and execute selected command
# FZF needs to be installed
#------------------------------------------------------------------
fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

#-------
# ALIAS
#-------
alias ls=exa
alias ll="exa -l"
alias q=exit
alias v=nvim
alias lg=lazygit

#--------------
# Key bindings
#--------------
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

