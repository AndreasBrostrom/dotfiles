
function upgrade
    function _fn_upgrade_deconstructor
        functions -e _fn_upgrade_flatpak
        functions -e _fn_upgrade_snap
        functions -e _fn_upgrade_deconstructor
    end

    function _fn_upgrade_flatpak
        echo -e "\033[32mflatpak\033[0m"
        sudo flatpak update -y
    end
    function _fn_upgrade_snap
        echo -e "\033[32msnap\033[0m"
        sudo snap refresh
    end

    # Arch
    # pacman yay
    if exist yay
        sudo -v
        echo -e '\033[1mFully upgrading system and packages...\033[0m'
        echo -e '\033[1;32myay\033[0m'
        yay -Syyu --sudoloop --noconfirm --color=always
        exist flatpak && _fn_upgrade_flatpak
        exist snap && _fn_upgrade_snap
        notify-send 'yay' '<i>System upgrade is complet.</i>' --urgency=normal
        sudo --reset-timestamp
        echo -e '\033[1mFull upgrade completed\033[0m'
        _fn_upgrade_deconstructor
        return
    end
    # pacman
    if exist pacman
        sudo -v
        echo -e '\033[1mFully upgrading system and packages...\033[0m'
        echo -e '\033[1;32myay\033[0m'
        sudo pacman -Syyu --noconfirm --color=always
        exist flatpak && _fn_upgrade_flatpak
        exist snap && _fn_upgrade_snap
        notify-send 'pacman' '<i>System upgrade is complet.</i>' --urgency=normal
        sudo --reset-timestamp
        echo -e '\033[1mFull upgrade completed\033[0m'
        _fn_upgrade_deconstructor
        return
    end

    # Ubuntu
    # termux apt pkg
    if exist pkg
        echo -e '\033[1mFully upgrading system and packages...\033[0m'
        echo -e '\033[1;32mpkg\033[0m'
        pkg upgrade -y
        pkg autoclean
        exist termux-notification && termux-notification -i "tuUpdatePKG" -t "Termux PKG" -c "System upgrade is complet." --led-color AAFF00
        echo -e '\033[1mFull upgrade completed\033[0m'
        _fn_upgrade_deconstructor
        return
    end
    # apt
    if exist apt
        sudo -v
        echo -e '\033[1mFully upgrading system and packages...\033[0m'
        echo -e "\033[32mapt\033[0m"
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt autoremove -y
        exist flatpak && _fn_upgrade_flatpak
        exist snap && _fn_upgrade_snap
        notify-send 'apt' '<i>System upgrade is complet.</i>' --urgency=normal
        echo -e "\033[1mAll updates are completed.\033[0m"
        _fn_upgrade_deconstructor
        return
    end
end