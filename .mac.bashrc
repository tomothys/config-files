#region --------- HOMEBREW
eval "$(homebrew/bin/brew shellenv)"
#endregion

if [ -f ~/personal-workspace/config-files/.bashrc ]; then
    source ~/personal-workspace/config-files/.bashrc
fi
