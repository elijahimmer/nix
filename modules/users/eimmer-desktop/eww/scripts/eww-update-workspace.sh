data="(box :class \"workspaces\" :orientation \"h\" :halign \"start\" "

active_workspace() {
	echo "(button :onclick \"hyprctl dispatch workspace $1\" :class \"active-workspace workspace\" $1) "
}

workspace() {
	echo "(button :onclick \"hyprctl dispatch workspace $1\" :class \"workspace\" $1) "
}

raw_arr=$(hyprctl workspaces | rg "\(\d+\)" -o)
arr=()

for i in $raw_arr
do
	i=${i:1:$((${#i} - 2))}
	arr+=($i)
done

arr_sorted=( )
while IFS= read -r item; do
  arr_sorted+=( "$item" )
done < <(printf '%s\n' "${arr[@]}" | sort -t _ -g)

for i in ${arr_sorted[@]}
do
	if [ $1 == $i ]; then
		data="$data$(active_workspace $i)"

	else
		data="$data$(workspace $i)"
	fi
done

data="$data)"

eww -c /flakes/nix/modules/users/eimmer-desktop/eww/ update workspaces="$data"
