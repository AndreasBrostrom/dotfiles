function upgrade
    if test (count $argv) -gt 0
        # Loop through all arguments
        for arg in $argv
            switch $arg
                case "--help"
                    echo -e "\033[1mUsage: upgrade\033[0m [--help]"
                    echo -e "This script attempts to fully upgrade your system using the OS-specific package manager."
                    echo -e "If snap, flatpak or sitrep exist this will also upgrade."
                    echo -e "\n\033[1mOptions:\033[0m"
                    echo -e "  \033[1;32m--help\033[0m         Show this help message and exit"
                    return
            end
        end
    end

    function _fn_upgrade_deconstructor
        functions -e _fn_upgrade_flatpak
        functions -e _fn_upgrade_snap
        functions -e _fn_upgrade_dotfiles
        functions -e _fn_upgrade_deconstructor
    end

    function _fn_upgrade_flatpak
        if exist flatpak
            echo -e "\033[1;32mflatpak\033[0m"
            sudo flatpak update -y
        end
    end
    function _fn_upgrade_snap
        if exist snap
            echo -e "\033[1;32msnap\033[0m"
            sudo snap refresh
        end
    end
    function _fn_upgrade_dotfiles
        if exist sitrep
            echo -e '\033[1;32msitrep\033[0m'
            sitrep -u
        end
    end

    echo -e '\033[1mFully upgrading system and packages...\033[0m'

    # Arch
    if exist pacman
        # pacman paru
        if exist paru
            sudo -v
            echo -e '\033[1;32mparu\033[0m'
            paru -Syyu --sudoloop --noconfirm --color=always
            _fn_upgrade_flatpak
            _fn_upgrade_snap
            set orphan (paru -Qtdq)
            if ! test (count $orphan) -eq 0
                echo -e '\n\033[1mOrphan package dependencies:\033[0m'
                for i in $orphan; echo " $i"; end
                echo -e '\033[2mTo remove them:           paru -Rc $(paru -Qtdq)\033[0m'
                echo -e '\033[2mTo set them as explicit:  paru -D --asexplicit PKG\033[0m'
            end
            _fn_upgrade_dotfiles
            exist notify-send && notify-send 'paru' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
            echo -e '\033[1mFull upgrade completed\033[0m'
            sudo --reset-timestamp
            _fn_upgrade_deconstructor
            return
        end
        # pacman yay
        if exist yay
            sudo -v
            echo -e '\033[1mFully upgrading system and packages...\033[0m'
            echo -e '\033[1;32myay\033[0m'
            yay -Syyu --sudoloop --noconfirm --color=always
            exist flatpak && _fn_upgrade_flatpak
            exist snap && _fn_upgrade_snap
            set orphan (yay -Qtdq)
            if ! test (count $orphan) -eq 0
                echo -e '\n\033[1mOrphan package dependencies:\033[0m'
                for i in $orphan; echo " $i"; end
                echo -e '\033[2mTo remove them:           yay -Rc $(yay -Qtdq)\033[0m'
                echo -e '\033[2mTo set them as explicit:  yay -D --asexplicit PKG\033[0m'
            end
            _fn_upgrade_dotfiles
            exist notify-send && notify-send 'yay' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
            echo -e '\033[1mFull upgrade completed\033[0m'
            sudo --reset-timestamp
            _fn_upgrade_deconstructor
            return
        end

        # pacman (default)
        echo -e '\033[1;32mpacman\033[0m'
        sudo pacman -Syyu --noconfirm --color=always
        _fn_upgrade_flatpak
        _fn_upgrade_snap
        set orphan (pacman -Qtdq)
        if ! test (count $orphan) -eq 0
            echo -e '\n\033[1mOrphan package dependencies:\033[0m'
            for i in $orphan; echo " $i"; end
            echo -e '\033[2mTo remove them:           sudo pacman -Rc $(pacman -Qtdq)\033[0m'
            echo -e '\033[2mTo set them as explicit:  sudo pacman -D --asexplicit PKG\033[0m'
        end
        _fn_upgrade_dotfiles
        exist notify-send && notify-send 'pacman' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
        echo -e '\033[1mFull upgrade completed\033[0m'
        sudo --reset-timestamp
        _fn_upgrade_deconstructor
        return
    end

    # Debian
    if exist apt
        # termux pkg (apt wrapper)
        if exist pkg
            echo -e '\033[1;32mpkg\033[0m'
            pkg upgrade -y
            pkg autoclean
            _fn_upgrade_dotfiles
            exist termux-notification && termux-notification -i "tuUpdatePKG" -t "Termux PKG" -c "System upgrade is completed." --led-color AAFF00 >/dev/null 2>/dev/null
            echo -e '\033[1mFull upgrade completed\033[0m'
            _fn_upgrade_deconstructor
            return
        end
        

        # apt (default)
        sudo -v
        echo -e "\033[32mapt\033[0m"
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt autoremove -y
        _fn_upgrade_flatpak
        _fn_upgrade_snap
        _fn_upgrade_dotfiles
        exist notify-send && notify-send 'apt' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
        echo -e "\033[1mAll updates are completed.\033[0m"
        _fn_upgrade_deconstructor
        return
    end

    # Fedora
    if exist dfn
        # dfn (default)
        sudo -v
        echo -e "\033[32mdfn\033[0m"
        sudo dnf upgrade -y

        _fn_upgrade_flatpak
        _fn_upgrade_snap
        _fn_upgrade_dotfiles
        exist notify-send && notify-send 'dfn' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
        echo -e "\033[1mAll updates are completed.\033[0m"
        _fn_upgrade_deconstructor
        return
    end
end