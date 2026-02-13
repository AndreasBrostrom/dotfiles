function arc
    set -l mode ""
    set -l output ""
    set -l inputs

    # --- Parse arguments ---
    while test (count $argv) -gt 0
        switch $argv[1]
            case '-d'
                set mode dir
                set -e argv[1]

            case '-f'
                set mode file
                set -e argv[1]

            case '-o'
                set -e argv[1]
                set output $argv[1]
                set -e argv[1]

            case '*'
                set inputs $inputs $argv[1]
                set -e argv[1]
        end
    end

    # --- Validation ---
    if test -z "$output"
        echo "arc: no output file specified (-o)"
        return 1
    end

    if test -z "$mode"
        echo "arc: specify -d (directories) or -f (files)"
        return 1
    end

    # Ensure extension exists
    if not string match -rq '\.' -- $output
        echo "arc: output file must have an extension"
        return 1
    end

    # --- Detect archive type ---
    switch $output
        case '*.tar.gz' '*.tgz'
            tar czf $output $inputs

        case '*.tar.bz2' '*.tbz2'
            tar cjf $output $inputs

        case '*.tar.xz'
            tar cJf $output $inputs

        case '*.tar'
            tar cf $output $inputs

        case '*.zip'
            zip -r $output $inputs

        case '*.7z'
            7z a $output $inputs

        case '*.gz'
            if test (count $inputs) -ne 1
                echo "arc: .gz supports only one file"
                return 1
            end
            gzip -c $inputs[1] > $output

        case '*.bz2'
            if test (count $inputs) -ne 1
                echo "arc: .bz2 supports only one file"
                return 1
            end
            bzip2 -c $inputs[1] > $output

        case '*'
            echo "arc: unknown archive format: $output"
            return 1
    end
end
