
if not status is-interactive
    # Commands to run when not in interactive sessions can go here
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

# Theme configuration
set -gx GTK_THEME Adwaita-dark
set -gx GTK_SETTINGS_OVERRIDE_DIR $HOME/.config/gtk-3.0
set -gx QT_STYLE_OVERRIDE adwaita-dark
set -gx GTK_APPLICATION_PREFER_DARK_THEME 1

# set object colors for ls
eval (dircolors -c ~/.config/dir_colors)