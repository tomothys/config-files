#region --------- HOMEBREW 
eval "$(/opt/homebrew/bin/brew shellenv)"
#endregion

if [[ -f "$HOME/.pssst" ]]; then
    source $HOME/.pssst
fi

if [[ -f "$HOME/personal-workspace/config-files/.zshrc" ]]; then
    source $HOME/personal-workspace/config-files/.zshrc
fi
