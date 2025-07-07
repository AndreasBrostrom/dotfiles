
alias py='python'
alias vim='nvim'

# ADB
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'

alias adb-url='adb shell am start -a android.intent.action.VIEW -d '


# lock screen aliases
if test (string lower "$XDG_CURRENT_DESKTOP$XDG_SESSION_DESKTOP") = "xfce"
    alias lock 'xflock4'
    alias disable-autolock 'pkill -9 -f xflock4'
else if test (string lower "$XDG_CURRENT_DESKTOP$XDG_SESSION_DESKTOP") = "i3"
    alias lock 'i3exit lock'
    alias disable-autolock 'pkill -9 -f xautolock'
else
    alias lock 'xflock4 || i3exit lock || echo "No lock command found"'
    alias disable-autolock 'pkill -9 -f xflock4; pkill -9 -f xautolock'
end