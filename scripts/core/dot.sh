dot::list_contexts() {
	dotfiles_contexts=$(ls "$DOTFILES_PATH/scripts")
	dotly_contexts=$(ls "$DOTLY_PATH/scripts" | grep -v core)

	echo "$dotfiles_contexts" "$dotly_contexts" | sort -u
}

dot::list_context_scripts() {
	context="$1"

	dotfiles_scripts=$(ls -p "$DOTFILES_PATH/scripts/$context" 2>/dev/null | grep -v '/')
	dotly_scripts=$(ls -p "$DOTLY_PATH/scripts/$context" 2>/dev/null | grep -v '/')

	echo "$dotfiles_contexts" "$dotly_scripts" | sort -u
}

dot::list_scripts() {
	_list_scripts() {
		scripts=$(dot::list_context_scripts "$1" | xargs -I_ echo "dot $1 _")

		echo "$scripts"
	}

	dot::list_contexts | coll::map _list_scripts
}

dot::list_scripts_path() {
	dotfiles_contexts=$(find "$DOTFILES_PATH/scripts" -maxdepth 2 -perm /+111 -type f)
	dotly_contexts=$(find "$DOTLY_PATH/scripts" -maxdepth 2 -perm /+111 -type f | grep -v "$DOTLY_PATH/scripts/core")

	printf "%s\n%s" "$dotfiles_contexts" "$dotly_contexts" | awk -F"/" '!seen[$(NF-1),$NF]++' | sort
}
