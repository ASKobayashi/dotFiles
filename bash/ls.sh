#!/bin/sh

#test for gnu ls, use it if it exists
`command -v gls>/dev/null` 
if [ 0 -eq $? ] ; then
  gls --color=auto -Fh "$@" && gls -l "$@" | grep ^\- | awk -F " " '{sum += $5; count+=1} END {if(sum>1048576){printf("\t%0.2f megabytes",
  sum/1048576)} else {printf("\t%0.2f kilobytes",
  sum/1024);}} END {printf(" - total files: %d\n", count)}';
  exit
fi

# gnul ls responds to --help, bsd ls doesn't
`\ls --help >&/dev/null`
if [ 0 -eq $? ] ; then
  ls --color=auto -Fh "$@" && ls -l "$@" | grep ^\- | awk -F " " '{sum += $5; count+=1} END {if(sum>1048576){printf("\t%0.2f megabytes",
  sum/1048576)} else {printf("\t%0.2f kilobytes",
  sum/1024);}} END {printf(" - total files: %d\n", count)}';
  exit 
fi

# Default to just regular old ls
ls "$@"
exit 
