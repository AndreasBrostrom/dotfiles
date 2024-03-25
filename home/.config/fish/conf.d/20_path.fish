set --export GTK_THEME Adwaita:dark 
set --export TERMINAL terminator
set --export TERM $TERMINAL

set --export EDITOR nvim
set --export GIT_EDITOR nvim
set --export DISPLAY :0

# Paths
fish_add_path -Pp $HOME/Programs/bin
fish_add_path -Pa $HOME/.bin

# Android
set --export ANDROID_HOME $HOME/.android/Sdk
set --export ANDROID_SDK_HOME $HOME/.android
set --export ANDROID_AVD_HOME $HOME/.android/avd
fish_add_path -Pa $ANDROID_HOME/tools
fish_add_path -Pa $ANDROID_HOME/tools/bin
fish_add_path -Pa $ANDROID_HOME/emulator
fish_add_path -Pa $ANDROID_HOME/platform-tools

fish_add_path -Pa $HOME/.yarn/bin
fish_add_path -Pa $HOME/.cargo/bin

# Manager
fish_add_path -Pa $HOME/Repositories/Manager/bin
