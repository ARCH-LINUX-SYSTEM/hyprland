#!/usr/bin/env bash

set -euo pipefail

TOP_N="${1:-15}"

echo "=== MEMORY OVERVIEW ==="
free -h

echo
echo "=== TOP ${TOP_N} PROCESSES BY RSS ==="
ps -eo pid,user,%mem,rss,comm,args --sort=-rss | head -n "$((TOP_N + 1))" || true

echo
echo "=== TOP GROUPED BY COMMAND NAME ==="
ps -eo rss,comm --no-headers | awk '
{
	rss[$2] += $1
	cnt[$2]++
}
END {
	for (name in rss)
		printf "%-9.1f MB  (%d proc)  %s\n", rss[name] / 1024, cnt[name], name
}' | sort -rn | head -n "$TOP_N" || true

echo
echo "=== SWAP USAGE ==="
if [ "$(swapon --show --noheadings 2>/dev/null | wc -l)" -eq 0 ]; then
	echo "No swap in use."
else
	swapon --show
fi
