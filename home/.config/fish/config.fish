
if not status is-interactive
    # Commands to run when not in interactive sessions can go here
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

function ex
    if test -e "$argv[1]"
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via ex()" 
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

function exist
    if which $argv[1] 1>/dev/null 2>&1
        return 0
    else
        return 1
    end
end

# set object colors for ls
eval (dircolors -c ~/.dir_colors)