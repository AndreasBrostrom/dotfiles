
if not status is-interactive
    # Commands to run when not in interactive sessions can go here
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end


# set object colors for ls
eval (dircolors -c ~/.dir_colors)