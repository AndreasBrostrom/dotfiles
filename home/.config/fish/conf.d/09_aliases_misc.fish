
alias py='python'
alias vim='nvim'

# ADB
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'

alias adb-url='adb shell am start -a android.intent.action.VIEW -d '


# lock screen aliases
if test "$XDG_CURRENT_DESKTOP" = "XFCE" -o "$XDG_SESSION_DESKTOP" = "xfce"
    alias lock 'xflock4'
    alias disable-autolock 'pkill -9 -f xflock4'
else if test "$XDG_CURRENT_DESKTOP" = "i3" -o "$XDG_SESSION_DESKTOP" = "i3"
    alias lock 'i3exit lock'
    alias disable-autolock 'pkill -9 -f xautolock'
end
