#!/bin/sh -e

# ensure sort is consistent
export LC_ALL=C

if [ "$#" -lt 3 ]; then
	echo "missing arguments" >&2
	exit 1
fi

TIMESTAMP="$1"
OUTFILE="$2"
shift 2

find "$@" -type d -print0 | xargs -0r chmod 755 --
find "$@" -type f -print0 | xargs -0r chmod 644 --
find "$@" -print0 -print0 | xargs -0r touch --no-dereference --date="$TIMESTAMP" --
find "$@" | sort | zip -X -@ "$OUTFILE"



