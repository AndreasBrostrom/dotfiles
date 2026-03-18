
# Windows Linux Subsystem
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    if [[ "$PWD" = "/mnt/c/Windows/system32" || "$PWD" = "/mnt/c/WINDOWS/system32" ]]; then
        cd ~
    fi

    alias explorer='explorer.exe'
    alias calc='calc.exe'

    alias terminator='detach terminator'
    alias nemo='detach nemo'
fi
