#!/usr/bin/env bash
# Author: Dolores Portalatin <hello@doloresportalatin.info>
# Dependencies: imagemagick, i3lock-color-git, scrot, wmctrl (optional)
set -o errexit -o noclobber -o nounset

# Determines the brightness of the screenshot
# $1 - Image file to check
# $2 - Arguments passed to 'convert'. For example this can be used to crop the image, to just sample a part of it
get_brightness() {
    # Quite fast way of getting a brightness value
    convert "$1" +repage $2 -colorspace gray -format "%[fx:round(100*mean)]" info:
}

# Determines the width of the given text when processed using the text_options flag
# $1 - The text to checked
# Prints the text width in pixels to stdout
get_text_width() {
    # empty text or text containing only whitespace would throw an error so we just return zero
    if [ -z "${1// }" ]; then
        echo 0
        return
    fi
    convert "${text_options[@]}" label:"$1" -format "%[fx:w]\n" info:
}

# Calculates the absolute positions for the lock and text or the given monitor, generates the command line arguemnts
# for convert that apply the lock icon and the text to the proper locations and adds them to the decorations_params array
# $1 - Monitor Width
# $2 - Monitor Height
# $3 - X Offset
# $4 - Y Offset
# Prints the brigthness in the center of the monitor to file descriptor 3
# This is used to determine the average brightness in the centers of all the monitors and to then set the proper colors
# for i3lock-color
process_monitor() {
    width=$1
    height=$2
    x_offset=$3
    y_offset=$4

    # center coordinates relative to the current monitor
    x_mid=$((width / 2))
    y_mid=$((height / 2))

    # absolute X, Y coordinates of the top left edge of the text
    x_text=$((x_offset + x_mid - (text_width / 2)))
    y_text=$((y_offset + y_mid + 160))

    # absolute X, Y coordinates of the top left edge of the icon
    # The lock icon has dimensions 60x60, we subtract half of that from each dimension
    # If the lock dimensions ever change, these values here need to be changed too
    x_icon=$((x_offset + x_mid - 30))
    y_icon=$((y_offset + y_mid - 30))

    # Get brightness for the middle of the monitor
    brightness="$(get_brightness "$image" "-crop 100x100+$x_icon+$y_icon")"

    if [ "$brightness" -gt "$threshold" ]; then # bright background image and black text
        text_color="black"
        icon="$scriptpath/icons/lockdark.png"
    else # dark background image and white text
        text_color="white"
        icon="$scriptpath/icons/lock.png"
    fi

    decoration_params+=(+repage)

    if [ "$text_width" -ne 0 ]; then
        # Only add text flags, if there actually is text
        decoration_params+=("${text_options[@]}" -fill "$text_color" -annotate "+$x_text+$y_text" "$text")
    fi

    decoration_params+=("$icon" -geometry "+$x_icon+$y_icon" -composite)


    # Write brightness to file descriptor
    exec 3<<< "$brightness"
}

# get path where the script is located to find the lock icon
scriptpath=$(readlink -f -- "$0")
scriptpath=${scriptpath%/*}

hue=(-level "0%,100%,0.6")
effect=(-filter Gaussian -resize 20% -define "filter:sigma=1.5" -resize 500.5%)
# default system sans-serif font
font=$(convert -list font | awk "{ a[NR] = \$2 } /family: $(fc-match sans -f "%{family}\n")/ { print a[NR-1]; exit }")

image="$(mktemp --suffix=.png)"

# brightness value to compare to, everything above is considered white and everything below black
threshold="40"

desktop=""
shot=(import -window root)
i3lock_cmd=(i3lock -i "$image")
shot_custom=false

options="Options:
    -h, --help       This help menu.

    -d, --desktop    Attempt to minimize all windows before locking.

    -g, --greyscale  Set background to greyscale instead of color.

    -p, --pixelate   Pixelate the background instead of blur, runs faster.

    -f <fontname>, --font <fontname>  Set a custom font.

    -t <text>, --text <text> Set a custom text prompt.

    -l, --listfonts  Display a list of possible fonts for use with -f/--font.
                     Note: this option will not lock the screen, it displays
                     the list and exits immediately.

    -n, --nofork     Do not fork i3lock after starting.

    --               Must be last option. Set command to use for taking a
                     screenshot. Default is 'import -window root'. Using 'scrot'
                     or 'maim' will increase script speed and allow setting
                     custom flags like having a delay."

# move pipefail down as for some reason "convert -list font" returns 1
set -o pipefail
trap 'rm -f "$image"' EXIT
temp="$(getopt -o :hdnpglt:f: -l desktop,help,listfonts,nofork,pixelate,greyscale,text:,font: --name "$0" -- "$@")"
eval set -- "$temp"

# l10n support
text="Type password to unlock"
case "${LANG:-}" in
    de_* ) text="Bitte Passwort eingeben" ;; # Deutsch
    da_* ) text="Indtast adgangskode" ;; # Danish
    en_* ) text="Type password to unlock" ;; # English
    es_* ) text="Ingrese su contraseña" ;; # Española
    fr_* ) text="Entrez votre mot de passe" ;; # Français
    id_* ) text="Masukkan kata sandi Anda" ;; # Bahasa Indonesia
    it_* ) text="Inserisci la password" ;; # Italian
    pl_* ) text="Podaj hasło" ;; # Polish
    pt_* ) text="Digite a senha para desbloquear" ;; # Português
    ru_* ) text="Введите пароль" ;; # Russian
    * ) text="Type password to unlock" ;; # Default to English
esac

while true ; do
    case "$1" in
        -h|--help)
            printf "Usage: %s [options]\n\n%s\n\n" "${0##*/}" "$options"; exit 1 ;;
        -d|--desktop) desktop=$(command -V wmctrl) ; shift ;;
        -g|--greyscale) hue=(-level "0%,100%,0.6" -set colorspace Gray -separate -average) ; shift ;;
        -p|--pixelate) effect=(-scale 10% -scale 1000%) ; shift ;;
        -f|--font)
            case "$2" in
                "") shift 2 ;;
                *) font=$2 ; shift 2 ;;
            esac ;;
        -t|--text) text=$2 ; shift 2 ;;
        -l|--listfonts)
            convert -list font | awk -F: '/Font: / { print $2 }' | sort -du | command -- ${PAGER:-less}
            exit 0 ;;
        -n|--nofork) i3lock_cmd+=(--nofork) ; shift ;;
        --) shift; shot_custom=true; break ;;
        *) echo "error" ; exit 1 ;;
    esac
done

if "$shot_custom" && [[ $# -gt 0 ]]; then
    shot=("$@");
fi

text_options=(-font "$font" -pointsize 26)
text_width=$(get_text_width "$text")

command -- "${shot[@]}" "$image"

# All the arguments to be passed to convert, to add the lock and text to the monitors is collected here so that we can
# apply them in a single call to convert
decoration_params=()

# We collect the brightness values from all the monitors and average them, from that we determine which flags to pass to
# i3lock-color since the colors for i3lock-color cannot be specified per monitor.
# We could also just call get_brightness on the whole image but process_monitor samples only the center
# of the screen where the lock actually is, so we get a better value for the brightness
sum_brightness=0
num_monitors=0

# Loop through all connected monitors (as reported by xrandr)
# For each monitor the convert arguments to add the lock and text to that monitor are generated
while read -r monitor; do
    if [[ "$monitor" =~ ([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+) ]]; then
        width=${BASH_REMATCH[1]}
        height=${BASH_REMATCH[2]}
        x_offset=${BASH_REMATCH[3]}
        y_offset=${BASH_REMATCH[4]}

        # We get the return value from the function by using a new file descriptor
        # The traditional approach of using $(process_monitor ...) and echo doesn't work because it forks into a
        # subshell and then process_monitor cannot access decoration_params
        exec 3>&-
        process_monitor "$width" "$height" "$x_offset" "$y_offset" && read -r brightness <&3
        exec 3>&-

        sum_brightness=$((brightness + sum_brightness))
        num_monitors=$((num_monitors + 1))
    fi
done <<<"$(xrandr --verbose | grep "\bconnected\b")"

convert "$image" "${hue[@]}" "${effect[@]}" "${decoration_params[@]}" "$image"

avg_brightness=$((sum_brightness / num_monitors))

if [ "$avg_brightness" -gt "$threshold" ]; then # Screenshot is rather bright, so we use dark colors
    param=("--textcolor=00000000" "--insidecolor=0000001c" "--ringcolor=0000003e" \
        "--linecolor=00000000" "--keyhlcolor=ffffff80" "--ringvercolor=ffffff00" \
        "--separatorcolor=22222260" "--insidevercolor=ffffff1c" \
        "--ringwrongcolor=ffffff55" "--insidewrongcolor=ffffff1c")
else # Bright colors
    param=("--textcolor=ffffff00" "--insidecolor=ffffff1c" "--ringcolor=ffffff3e" \
        "--linecolor=ffffff00" "--keyhlcolor=00000080" "--ringvercolor=00000000" \
        "--separatorcolor=22222260" "--insidevercolor=0000001c" \
        "--ringwrongcolor=00000055" "--insidewrongcolor=0000001c")
fi

xkb-switch -s us

# If invoked with -d/--desktop, we'll attempt to minimize all windows (ie. show
# the desktop) before locking.
${desktop} ${desktop:+-k on}

# try to use i3lock with prepared parameters
if ! "${i3lock_cmd[@]}" "${param[@]}" >/dev/null 2>&1; then
    # We have failed, lets get back to stock one
    "${i3lock_cmd[@]}"
fi

# As above, if we were passed -d/--desktop, we'll attempt to restore all windows
# after unlocking.
${desktop} ${desktop:+-k off}

sleep 10
#xset dpms force suspend
xset dpms force off
