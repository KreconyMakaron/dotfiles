#!/usr/bin/env bash
if [[ $2 == "image" ]]; then
	cliphist list | head -n$1 | tail -n1 | cliphist decode > /tmp/clipboard_ags_image
else
	echo $(cliphist list | head -n$1 | tail -n1 | cliphist decode)
fi
