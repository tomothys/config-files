#region --------- HOMEBREW
case ":$PATH:" in
  *":/opt/homebrew/bin:"*) ;;
  *) export PATH="/opt/homebrew/bin:$PATH" ;;
esac
#endregion

if [ -f ~/personal-workspace/config-files/.bashrc ]; then
    source ~/personal-workspace/config-files/.bashrc
fi
