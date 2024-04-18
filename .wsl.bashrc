#region --------- LINUXBREW
case ":$PATH:" in
  *":/home/linuxbrew/.linuxbrew/bin:"*) ;;
  *) export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" ;;
esac
#endregion

#region --------- FUNCTIONS
rmi() {
    if test -d ./infrastructure; then
        sudo chmod -R 777 infrastructure && rm -rf infrastructure

        if test -d ./infrastructure; then
            echo -e '\e[0;31mCould not remove infrastructure folder\e[0m'
        else
            echo -e '\e[0;32minfrastructure successfully removed\e[0m'
        fi
    else
        echo -e '\e[0;31minfrastructure directory not found\e[0m'
    fi
}
alias rm-infrastructure=rmi
#endregion

#region --------- ALIASES
alias open=explorer.exe
#endregion

if [ -f ~/personal-workspace/config-files/.bashrc ]; then
    source ~/personal-workspace/config-files/.bashrc
fi
