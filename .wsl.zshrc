#region --------- LINUXBREW 
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#endregion

if [[ -f "$HOME/personal-workspace/config-files/.zshrc" ]]; then
    source $HOME/personal-workspace/config-files/.zshrc
fi
