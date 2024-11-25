#!/bin/bash

# simple screen information script

wms=(i3 berry dwm openbox twobwm pekwm simplewm labwc simplewc)
bars=(waybar polybar)

# define colors for color-echo
red="\e[31m"
grn="\e[32m"
ylw="\e[33m"
cyn="\e[36m"
blu="\e[34m"
prp="\e[35m"
rst="\e[0m"

color-echo() {  # print with colors
      printf "\e[22C%s$cyn%-12s  $rst%s\n" "$1" "$2" "$3"
}

print-kernel() {
   color-echo "├ " "Kernel" "$(uname -smr)"
}

print-uptime() {
   up=$(</proc/uptime)
   up=${up//.*}                # string before first . is seconds
   days=$((${up}/86400))       # seconds divided by 86400 is days
   hours=$((${up}/3600%24))    # seconds divided by 3600 mod 24 is hours
   mins=$((${up}/60%60))       # seconds divided by 60 mod 60 is mins
   
   color-echo "Uptime" "$(echo $days'd '$hours'h '$mins'm')"
}

print-shell() {
   color-echo "└ "  "Shell" $SHELL
}

print-term() {
   color-echo "├ " "Terminal" $TERM
}

print-cpu() {
   cpu=$(grep -m1 -i 'model name' /proc/cpuinfo)

   color-echo "├ " "CPU" "${cpu#*: }" # everything after colon is processor name
}

print-disk() {
   disk=$(df -h / | awk 'NR==2 {total=$2; used=$3; print used" / "total}')
   
   color-echo "Disk" "$disk"
}

print-mem() {

   if [[ $(free -m) =~ "buffers" ]]; then # using old format
      mem=$(free -m | awk 'NR==2 {total=$2} NR==3 {used=$3; print used"M / "total"M"}')
   else # using new format
      mem=$(free -m | awk 'NR==2 {total=$2} NR==2 {used=$3; print used"M / "total"M"}')
   fi

   color-echo "├ " "Mem" "$mem"
}

print-wm() {
   for wm in ${wms[@]}; do          # pgrep through wmname array
      pid=$(pgrep -x -u $USER $wm) # if found, this wmname has running process
   if [[ "$pid" ]]; then
      color-echo "├ " "WM" $wm
      break
   fi
done
}

print-bar() {
   for bar in ${bars[@]}; do
      pid=$(pgrep -x -u $USER $bar)
   if [[ "$pid" ]]; then
      color-echo "├ " "Bar" $bar
      break
   fi
   done
}

print-distro() {
   [[ -e /etc/os-release ]] && source /etc/os-release
   if [[ -n "$PRETTY_NAME" ]]; then
      color-echo "├ " "OS" "$PRETTY_NAME" 
   else
      color-echo "├ " "OS" "not found"
   fi
}

print-resolution() {
   if [[ $DISPLAY ]]; then
      res=$(xwininfo -root | grep 'geometry' | awk '{print $2}' | cut -d+ -f1)
   else
      for dev in /sys/class/drm/*/modes; do
         read -r single_res _ < "$dev"

         [[ $single_res ]] && res="${single_res}"
      done
   fi

   color-echo "├ " "Resolution" $res
}

print-colors() {

   printf "\e[%bC" "31" 
   for i in {0..7}; do echo -en "\e[$((30+$i))m\uf111 ${colors[i]} \e[0m"; done
   echo

}

print-image() {
   if [ -z $1 ]; then
      printf "$red%10s$rst\n" '                 	'
      printf "$red%10s$rst\n" '   █     █▀▀▀  █▀▀▀█	'
      printf "$red%10s$rst\n" '   █     █▀▀▀  ▀▀▀▄▄	'
      printf "$red%10s$rst\n" '   █▄▄█  █     █▄▄▄█	'
      printf "$red%10s$rst\n" '    			'
      printf "$red%10s$rst\n" '    			'
      printf "$red%10s$rst\n" '   			'
      printf '\e[%sA\e[9999999D' "${lines:-9}"
   elif [ $TERM = "xterm-kitty" ]; then
      kitty +kitten icat --align left --place 40x40@0x5 $1
      printf '\e[%sA\e[9999999D' "-11"
   elif [ $TERM = "foot" ]; then
      echo -n "  " && img2sixel -w 140 $1
      printf '\e[%sA\e[9999999D' "${lines:-11}"
   fi
}

print-image $1

printf "\e[21C%s\n" "System:"
print-distro
print-kernel
print-cpu
print-mem
print-wm
print-bar
print-resolution
print-term
print-shell
echo
print-colors
echo
