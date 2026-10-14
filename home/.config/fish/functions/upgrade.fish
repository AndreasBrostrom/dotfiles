function upgrade
    if test (count $argv) -gt 0
        # Loop through all arguments
        for arg in $argv
            switch $arg
                case "--help"
                    echo -e "\033[1mUsage:\033[0m upgrade [--help]"
                    echo -e ""
                    echo -e "\033[1mDescription:\033[0m"
                    echo -e "  Fully upgrades your system using the detected package manager."
                    echo -e ""
                    echo -e "\033[1mSupported Package Managers:\033[0m"
                    echo -e "  \033[1;34mArch Linux:\033[0m    paru, yay, pacman"
                    echo -e "  \033[1;34mDebian/Ubuntu:\033[0m apt, pkg (Termux)"
                    echo -e "  \033[1;34mFedora:\033[0m        dnf"
                    echo -e ""
                    echo -e "\033[1mAdditional Features:\033[0m"
                    echo -e "  - Automatically upgrades Flatpak packages if installed"
                    echo -e "  - Automatically upgrades Snap packages if installed"
                    echo -e "  - Runs sitrep (dotfiles manager) if installed"
                    echo -e "  - Lists orphaned packages (Arch-based systems)"
                    echo -e "  - Recommends cache cleaning when package caches exceed 10 GiB (Arch-based systems)"
                    echo -e ""
                    echo -e "\033[1mOptions:\033[0m"
                    echo -e "  \033[1;32m--help\033[0m    Show this help message and exit"
                    return
            end
        end
    end

    function _fn_upgrade_deconstructor
        functions -e _fn_upgrade_flatpak
        functions -e _fn_upgrade_snap
        functions -e _fn_upgrade_dotfiles
        functions -e _fn_upgrade_cache_hint
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
            sitrep -u -i
        end
    end

    # Recommends cache cleaning when the package caches exceed 10 GiB.
    # Usage: _fn_upgrade_cache_hint paru|yay|pacman
    function _fn_upgrade_cache_hint
        set -l limit 10737418240
        set -l dirs /var/cache/pacman/pkg
        set -l cmds

        switch $argv[1]
            case paru
                set -a dirs $HOME/.cache/paru
                set cmds 'paru -Sc' 'paru -Scc'
            case yay
                set -a dirs $HOME/.cache/yay
                set cmds 'yay -Sc' 'yay -Scc'
            case '*'
                set cmds 'sudo pacman -Sc' 'sudo pacman -Scc'
        end

        set -l total 0
        set -l report
        for dir in $dirs
            test -d $dir; or continue
            set -l size (du -sb $dir 2>/dev/null | string split -f1 \t)
            test -n "$size"; or continue
            set total (math $total + $size)
            set -a report (printf ' %s  %s' (numfmt --to=iec $size) $dir)
        end

        if test $total -gt $limit
            echo -e "\n\033[1mPackage caches are large ("(numfmt --to=iec $total)"):\033[0m"
            for line in $report; echo $line; end
            if exist paccache
                echo -e '\033[2mKeep only the latest version:  sudo paccache -rk1\033[0m'
            end
            echo -e "\033[2mClean uninstalled packages:     $cmds[1]\033[0m"
            echo -e "\033[2mClear everything:               $cmds[2]\033[0m"
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
            _fn_upgrade_dotfiles
            set orphan (paru -Qtdq)
            if ! test (count $orphan) -eq 0
                echo -e '\n\033[1mOrphan package dependencies:\033[0m'
                for i in $orphan; echo " $i"; end
                echo -e '\033[2mTo remove them:           paru -Rns $(paru -Qtdq)\033[0m'
                echo -e '\033[2mTo set them as explicit:  paru -D --asexplicit PKG\033[0m'
            end
            _fn_upgrade_cache_hint paru
            exist notify-send && notify-send 'paru' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
            echo -e '\n\033[1mFull upgrade completed\033[0m'
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
            _fn_upgrade_dotfiles
            set orphan (yay -Qtdq)
            if ! test (count $orphan) -eq 0
                echo -e '\n\033[1mOrphan package dependencies:\033[0m'
                for i in $orphan; echo " $i"; end
                echo -e '\033[2mTo remove them:           yay -Rns $(yay -Qtdq)\033[0m'
                echo -e '\033[2mTo set them as explicit:  yay -D --asexplicit PKG\033[0m'
            end
            _fn_upgrade_cache_hint yay
            exist notify-send && notify-send 'yay' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
            echo -e '\n\033[1mFull upgrade completed\033[0m'
            sudo --reset-timestamp
            _fn_upgrade_deconstructor
            return
        end

        # pacman (default)
        echo -e '\033[1;32mpacman\033[0m'
        sudo pacman -Syyu --noconfirm --color=always
        _fn_upgrade_flatpak
        _fn_upgrade_snap
        _fn_upgrade_dotfiles
        set orphan (pacman -Qtdq)
        if ! test (count $orphan) -eq 0
            echo -e '\n\033[1mOrphan package dependencies:\033[0m'
            for i in $orphan; echo " $i"; end
            echo -e '\033[2mTo remove them:           sudo pacman -Rns $(pacman -Qtdq)\033[0m'
            echo -e '\033[2mTo set them as explicit:  sudo pacman -D --asexplicit PKG\033[0m'
        end
        _fn_upgrade_cache_hint pacman
        exist notify-send && notify-send 'pacman' '<i>System upgrade is completed.</i>' --urgency=normal >/dev/null 2>/dev/null
        echo -e '\n\033[1mFull upgrade completed\033[0m'
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
            echo -e '\n\033[1mFull upgrade completed\033[0m'
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
        echo -e "\n\033[1mAll updates are completed.\033[0m"
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
        echo -e "\n\033[1mAll updates are completed.\033[0m"
        _fn_upgrade_deconstructor
        return
    end
end