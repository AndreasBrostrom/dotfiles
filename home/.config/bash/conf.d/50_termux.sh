
# Android Termux Terminal
if [ -d "/data/data/com.termux" ]; then
    alias sudo='su'

    alias toast='termux-toast -g top'
    alias ring='termux-telephony-call'
    alias contacts='termux-contact-list | jq'
    alias vol='termux-volume'
    alias vib='termux-vibrate -f'
    alias clip='termux-clipboard-set'
    alias sms='termux-sms-send'
fi
