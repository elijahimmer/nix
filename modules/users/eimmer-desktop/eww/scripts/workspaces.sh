active_workspace() {
	echo "(button :onclick \"hyprctl dispatch workspace $1\" :class \"active-workspace workspace\" $1) "
}

workspace() {
	echo "(button :onclick \"hyprctl dispatch workspace $1\" :class \"workspace\" $1) "
}

render() {
	local -n ra=$1 

	out="(box :class \"works\" :orientation \"h\"	:space-evenly \"false\" "

	for i in ${ra[@]}
	do
		if [ $i -eq $2 ]
		then
			out+=$(active_workspace $i)
		else
			out+=$(workspace $i)
		fi
	done

	echo "$out (literal :valign \"center\" \"$3\"))"
}

sort_array() {
  local -n sai=$1
	arr_sorted=( )
	while IFS= read -r item; do
		arr_sorted+=( "$item" )
  done < <(printf '%s\n' "${sai[@]}" | sort -t _ -g)

	echo ${arr_sorted[@]}
}

add_workspace() {
	## Array of workspaces
	local -n w1=$1

	w1+=( $2 )
	
	w11=( $w1 )

	w=$(sort_array w11)

	echo ${w[@]}
}

remove_workspace() {
	local -n w1=$1

	w=( ${w1[@]/$2} )

	echo ${w[@]}
}

jumpstart() {
	arr=( )
	for i in $(hyprctl workspaces | rg "\(\-?\d+\)" -o)
	do
		i=${i:1:$((${#i} - 2))}
		arr+=($i)
	done

	sorted=$(sort_array arr)

	echo ${sorted[@]}
}

jumpstart_active() {
	hyprctl activeworkspace | rg "\-?\d+" -o | head -1
}

workspaces=$(jumpstart)
active_workspace=$(jumpstart_active)

handle() {
  dont_re_render=""
	case $1 in
		workspace*) active_workspace=$(echo $1 | rg -o "\d+") ;;
		createworkspace*) workspaces=$(add_workspace workspaces $(echo $1 | rg -o "\d+"))
											dont_re_render=true	;;
		destroyworkspace*) workspaces=$(remove_workspace workspaces $(echo $1 | rg -o "\d+")) ;;
		submap*) submap="${1:8:${#1}}" ;;
		*) dont_re_render=true ;;
  esac

	if [ -z $dont_re_render ]
	then
		render workspaces $active_workspace $submap
  	dont_re_render=""
	fi
}

render workspaces $active_workspace

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | \
	while read -r line
		do handle "$line"
	done

