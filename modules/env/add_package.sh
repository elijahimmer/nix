
main() {
	exec 3>&1;
	search_results=$(nix search --offline nixpkgs $1 2>&1 1>&3 | rg "\*.*qFlipper")
	exec 3>&-;

	exit_code=$?

	echo "${search_results[@]}"

	if [ -z $exit_code ]; then
		echo "$exit_code:" exiting
		exit $?
	fi

	declare -a dialog_options=()

	echo $search_results

	for i in "${search_results[@]}"
	do
		echo $i
		dialog_options+="${i} \"\" off "
	done


#	tput smcup
#	exec 3>&1;
#	result=$(dialog --radiolist "Choose A Package" 0 0  5 None "" on \
#		${dialog_option[@]} 2>&1 1>&3);
#
#	tput rmcup
#
#	exec 3>&-;

#	echo $result
#	echo "is $(printf "$search_results" | head -n 1)"
#
#	match='    ### INSERT PACKAGES HERE'
#	file='/flakes/nix/hosts/$HOSTNAME/packages.nix'
#
#	sed -i "s/$match/$match\n$@/" $file
}

if [ -z $1 ]; then
		echo Please enter a package!
		exit 0
fi

if [ "--global" == $1 ]; then
	echo "global_mode"

	if [ -z $2 ]; then
		echo Please enter a package!
		exit 1
	fi
	main $2
else
	main $1
fi

