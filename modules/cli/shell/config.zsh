export ZSH_AUTOSUGGEST_STRATEGY=history
eval "$(fzf --zsh)"

# sets the title of foot to the last executed command, used in hyprland/rules
setfoottitle () {
	printf '\e]2;%s\e\' $1
}

add-zsh-hook -Uz preexec setfoottitle

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# vi mode
bindkey -v
export KEYTIMEOUT=1

# https://nixos.wiki/wiki/Zsh#Zsh-autocomplete_not_working
bindkey "${key[Up]}" up-line-or-search
