#!/bin/sh

if [ $# -eq 0 ]; then
	echo "usage: $0 file ..." 1>&2
	exit 1
fi

if [ -d CVS ]; then :; else
	echo "$0: fatal error: no CVS directory!
	exit 1
fi
if [ -f CVS/Entries ] && [ -w CVS/Entries ]; then :; else
	echo "$0: fatal error: CVS/Entries file not writable!
	exit 1
fi

rv=0
for file in "$@"; do
	if [ -f "$file" ]; then :; else
		echo "$0: error: \"$file\" does not exist or is not a plain file"
		rv=1
		continue
	fi

	if grep "^/$file/" CVS/Entries > /dev/null 2>&1; then
		echo "$0: error: \"$file\" is already listed in CVS/Entries"
		rv=1
		continue
	fi

	echo "/$file/0/dummy timestamp//" >> CVS/Entries
	echo "$0: added \"$file\""
done
exit $rv