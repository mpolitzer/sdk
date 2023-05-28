#!/bin/sh

case "$1" in
start)
	/sbin/blkid | sed -e 's/\(^.\+\): /DEV="\1" /' | while read -r line; do
		eval "$line" && \
		  mkdir -p "/mnt/$LABEL" && \
		  mount "$DEV" "/mnt/$LABEL"
	done
	;;
stop)
	umount -afr
	;;
*)
	echo $"usage: $0 {start|stop}"
	;;
esac
