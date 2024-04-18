#region --------- HOMEBREW
case ":$PATH:" in
  *":/opt/homebrew/bin/brew:"*) ;;
  *) export PATH="/opt/homebrew/bin/brew:$PATH" ;;
esac
#endregion

if [ -f ~/personal-workspace/config-files/.bashrc ]; then
    source ~/personal-workspace/config-files/.bashrc
fi
