#!/bin/sh

TRASH_DIRECTORY="${XDG_DATA_HOME:-${HOME}/.local/share}/Trash"

if [[ "${TRASH_DIRECTORY}" = "" ]]; then
    TRASH_DIRECTORY="${XDG_DATA_HOME:-${HOME}/.local/share}/Trash"
fi

TRASH_COUNT=$(ls -U -1 "${TRASH_DIRECTORY}/files" | wc -l)

case "$1" in
    --clean)
        rm -rf ~/.local/share/Trash/files/
        rm -rf ~/.local/share/Trash/info/
        mkdir ~/.local/share/Trash/files
        mkdir ~/.local/share/Trash/info
        ;;
    *)
	echo "${TRASH_COUNT}"        
	#find ~/.local/share/Trash/files/ -maxdepth 1 | wc -l
        ;;
esac
