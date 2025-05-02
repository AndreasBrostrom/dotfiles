function upgrade
    function _fn_upgrade_deconstructor
        functions -e _fn_upgrade_flatpak
        functions -e _fn_upgrade_snap
        functions -e _fn_upgrade_deconstructor
    end

    function _fn_upgrade_flatpak
        if exist flatpak
            echo -e "\033[32mflatpak\033[0m"
            sudo flatpak update -y
        end
    end
    function _fn_upgrade_snap
        if exist snap
            echo -e "\033[32msnap\033[0m"
            sudo snap refresh
        end
    end
    function _fn_upgrade_sitrep
        if exist sitrep
            echo -e "\033[32msitrep\033[0m"
            sitrep -u
        end
    end

    echo -e '\033[1mFully upgrading system and packages...\033[0m'

    # Arch
    # pacman
    if exist pacman
        # pacman paru
        if exist paru
            sudo -v
            echo -e '\033[1;32mparu\033[0m'
            paru -Syyu --sudoloop --noconfirm --color=always
            _fn_upgrade_flatpak
            _fn_upgrade_snap
            exist notify-send && notify-send 'paru' '<i>System upgrade is complet.</i>' --urgency=normal >/dev/null 2>/dev/null
            echo -e '\033[1mFull upgrade completed\033[0m'
            set orphan (paru -Qtdq)
            if ! test (count $orphan) -eq 0
                echo -e '\n\033[1mOrphan package dependencies:\033[0m'
                for i in $orphan; echo " $i"; end
                echo -e '\033[2mManually run: paru -Rc $(paru -Qtdq)\033[0m'
            end
            _fn_upgrade_sitrep
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
            exist notify-send && notify-send 'yay' '<i>System upgrade is complet.</i>' --urgency=normal >/dev/null 2>/dev/null
            echo -e '\033[1mFull upgrade completed\033[0m'
            set orphan (yay -Qtdq)
            if ! test (count $orphan) -eq 0
                echo -e '\n\033[1mOrphan package dependencies:\033[0m'
                for i in $orphan; echo " $i"; end
                echo -e '\033[2mManually run: yay -Rc $(yay -Qtdq)\033[0m'
            end
            _fn_upgrade_sitrep
            sudo --reset-timestamp
            _fn_upgrade_deconstructor
            return
        end

        # pacman (default)
        echo -e '\033[1;32mpacman\033[0m'
        sudo pacman -Syyu --noconfirm --color=always
        _fn_upgrade_flatpak
        _fn_upgrade_snap
        exist notify-send && notify-send 'pacman' '<i>System upgrade is complet.</i>' --urgency=normal >/dev/null 2>/dev/null
        echo -e '\033[1mFull upgrade completed\033[0m'
        set orphan (pacman -Qtdq)
        if ! test (count $orphan) -eq 0
            echo -e '\n\033[1mOrphan package dependencies:\033[0m'
            for i in $orphan; echo " $i"; end
            echo -e '\033[2mManually run: sudo pacman -Rc $(pacman -Qtdq)\033[0m'
        end
        _fn_upgrade_sitrep
        sudo --reset-timestamp
        _fn_upgrade_deconstructor
        return
    end

    # Ubuntu
    if exist apt
        # termux pkg (apt wraper)
        if exist pkg
            echo -e '\033[1;32mpkg\033[0m'
            pkg upgrade -y
            pkg autoclean
            _fn_upgrade_sitrep
            exist termux-notification && termux-notification -i "tuUpdatePKG" -t "Termux PKG" -c "System upgrade is complet." --led-color AAFF00 >/dev/null 2>/dev/null
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
        _fn_upgrade_sitrep
        exist notify-send && notify-send 'apt' '<i>System upgrade is complet.</i>' --urgency=normal >/dev/null 2>/dev/null
        echo -e "\033[1mAll updates are completed.\033[0m"
        _fn_upgrade_deconstructor
        return
    end
end