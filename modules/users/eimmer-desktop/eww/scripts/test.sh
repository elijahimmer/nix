active_workspace() {
	echo "(button :onclick \"hyprctl dispatch workspace $1\" :class \"active-workspace workspace\" $1) "
}

workspace() {
	echo "(button :onclick \"hyprctl dispatch workspace $1\" :class \"workspace\" $1) "
}

render() {
	local -n ra=$1 

	out="(box "

	for i in ${ra[@]}
	do
		>&2 echo $i
		if [ $i -eq $2 ]
		then
			out+=$(active_workspace $i)
		else
			out+=$(workspace $i)
		fi
	done
	echo "$out)"
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

	w=$(sort_array w1)

	echo ${w[@]}
}

remove_workspace() {
	local -n w1=$1

	w=( ${w1[@]/$2} )

	echo ${w[@]}
}

t=( 1 2 5 10 )

w=( $(add_workspace t 3) )
c=( $(remove_workspace w 2) )

render c 2

echo ${w[@]}
echo ${c[@]}
