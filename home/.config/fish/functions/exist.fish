function exist
    if which $argv[1] 1>/dev/null 2>&1
        return 0
    else
        return 1
    end
end