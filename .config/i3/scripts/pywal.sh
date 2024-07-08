#!/bin/bash

# Color files
PFILE="$HOME/dotfiles/.config/polybar/colors.ini"
RFILE="$HOME/dotfiles/.config/rofi/colors/system.rasi"
WFILE="$HOME/.cache/wal/colors.sh"

# Wallpaper folder
FOLDER="$HOME/Pictures/wallpapers"

# Nitrogen Wallpeper
WALLPAPER1=$(awk '/^\[xin_0\]/{f=1} f==1&&/^file/{print $1;exit}' ~/.config/nitrogen/bg-saved.cfg | sed '/^file=/{s/^file=//;}')
WALLPAPER2=$(awk '/^\[xin_1\]/{f=1} f==1&&/^file/{print $1;exit}' ~/.config/nitrogen/bg-saved.cfg | sed '/^file=/{s/^file=//;}')
WALLPAPER3=$(awk '/^\[xin_-1\]/{f=1} f==1&&/^file/{print $1;exit}' ~/.config/nitrogen/bg-saved.cfg | sed '/^file=/{s/^file=//;}')
WALLPAPER=$WALLPAPER1

# Get colors
pywal_get() {
	wal -i "$WALLPAPER" --saturate 0.8
    ~/.config/dunst/launch_dunst.sh
}

# Change colors
change_color() {
    # return 0;
	# polybar
	sed -i -e "s/background = #.*/background = $BG/g" $PFILE
	sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
	sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
	sed -i -e "s/shade1 = #.*/shade1 = $SH1/g" $PFILE
	sed -i -e "s/shade2 = #.*/shade2 = $SH2/g" $PFILE
	sed -i -e "s/shade3 = #.*/shade3 = $SH3/g" $PFILE
	sed -i -e "s/shade4 = #.*/shade4 = $SH4/g" $PFILE
	sed -i -e "s/shade5 = #.*/shade5 = $SH5/g" $PFILE
	sed -i -e "s/shade6 = #.*/shade6 = $SH6/g" $PFILE
	sed -i -e "s/shade7 = #.*/shade7 = $SH7/g" $PFILE
	sed -i -e "s/shade8 = #.*/shade8 = $SH8/g" $PFILE
	
	# rofi
	cat > $RFILE <<- EOF
	/* colors */

	* {
	  al:    #00000000;
	  bg:    ${BG}FF;
	  bg1:   ${SH2}FF;
	  bg2:   ${SH3}FF;
	  bg3:   ${SH4}FF;
	  fg:    ${FGA}FF;
	}
	EOF
	
	polybar-msg cmd restart
}

# Random wallpaper
random() {
    ARR=($FOLDER/*)
    i=$(($RANDOM % ${#ARR[@]} + 1))
    random_wall=${ARR[$i]}
    echo $random_wall
}

# Main
if [[ -x "`which wal`" ]]; then
    if [ $1 == "-r" ]; then
        WALLPAPER=$(random)
        sed -i 's@file=.*@file='$WALLPAPER'@' ~/.config/nitrogen/bg-saved.cfg
        nitrogen --restore 2> /dev/null
    else
        if [[ ! -f "$WALLPAPER" ]]; then
            WALLPAPER=$WALLPAPER2
        fi
        if [[ ! -f "$WALLPAPER" ]]; then
            WALLPAPER=$WALLPAPER3
        fi
    fi
	if [[ "$WALLPAPER" ]]; then
		pywal_get "$WALLPAPER"

		# Source the pywal color file
		if [[ -e "$WFILE" ]]; then
			. "$WFILE"
		else
			echo 'Color file does not exist, exiting...'
			exit 1
		fi

		BG=`printf "%s\n" "$background"`
		FG=`printf "%s\n" "#FFFFFF"`
		FGA=`printf "%s\n" "$foreground"`
		SH1=`printf "%s\n" "${color2}"`
		SH2=`printf "%s\n" "${color4}"`
		SH3=`printf "%s\n" "${color2}"`
		SH4=`printf "%s\n" "${color4}"`
		SH5=`printf "%s\n" "${color2}"`
		SH6=`printf "%s\n" "${color4}"`
		SH7=`printf "%s\n" "${color2}"`
		SH8=`printf "%s\n" "${color4}"`

		change_color
	else
		echo -e "[!] Please enter the path to wallpaper. \n"
		echo "Usage : ./pywal.sh path/to/image"
	fi
else
	echo "[!] 'pywal' is not installed."
fi

