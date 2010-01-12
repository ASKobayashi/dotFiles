#!/bin/sh
ls --color=auto -Fh "$@" && ls -l "$@" | grep ^\- | awk -F " " '{sum += $5; count+=1} END {if(sum>1048576){printf("\t%0.2f megabytes",
sum/1048576)} else {printf("\t%0.2f kilobytes",
sum/1024);}} END {printf(" - total files: %d\n", count)}';
