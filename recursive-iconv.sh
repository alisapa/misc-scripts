#!/bin/bash
# Usage: recursive-iconv.sh [options] <base-path> <target-path> <from-code>
# 
# Produces a copy of a directory, with the text files converted to a different
# encoding.
# 
# The script will recursively descend into <base-path>, copying its directory
# structure into <target-path>. Any text files inside <base-path> will be
# converted from encoding <from-code> into either iconv's default encoding
# or the encoding specified in the [options]. Any non-text files will be copied
# without change.
#
# Example: recursive-iconv.sh flop flop-converted cp866

usage=$(cat << ...
Usage: $0 [options] <base-path> <target-path> <from-code>\n
\n
Important: No trailing / at end of <base-path> and <target-path>!\n
Also, script will break in case of any whitespace inside the directory.\n
\n
  -h\t\tPrint this message and exit.\n
  -p\t\tPretend mode. Don't actually convert the files.\n
  -t <to-code>\tConvert to a particular encoding instead of iconv's default.\n
  -v\t\tVerbose mode. Print the converted and excluded filenames.\n
...
)

# Parameters:
# $1: currently traversed directory
# $2: directory to write the converted files to
function recursive_traversal () {
  for fnam in $1/*; do
    fn=$(basename $fnam)
    if [[ -d "$1/$fn" ]]; then
      if [[ $pretend == 0 ]]; then
        mkdir -p "$2/$fn"
      fi
      # Recursively call the converter on directories
      recursive_traversal "$1/$fn" "$2/$fn"
    else
#      echo "Reach: $1/$fn"
      file -b "$1/$fn" | grep -iqe "text\|source"
      if [[ $? == 0 ]]; then
        if [[ $verbose == 1 ]]; then
          echo "CV: $1/$fn"
        fi

        if [[ $pretend == 0 ]]; then
          if [[ -n $tocode ]]; then
            iconv -f $fromcode -t $tocode -o "$2/$fn" "$1/$fn"
          else
            iconv -f $fromcode -o "$2/$fn" "$1/$fn"
          fi
        fi
      else
      # Write the excluded filenames into stderr, so that it can be redirected
      # into a separate file to manually verify that none of what was excluded
      # should have been converted
	if [[ $pretend == 0 ]]; then
	  cp "$1/$fn" "$2/$fn"
	fi
        if [[ $verbose == 1 ]]; then
          echo "EX: $1/$fn" >> /dev/stderr
        fi
      fi
    fi
  done
}

verbose=0
pretend=0
while getopts ":hpt:v" arg; do
  case "${arg}" in
    h) echo -e $usage
       exit 0 ;;
    p) pretend=1 ;;
    t) tocode=${OPTARG} ;;
    v) verbose=1 ;;
    :) echo "Missing argument for ${OPTOPT}."
       echo -e $usage
       exit 1 ;;
    ?) echo "Unknown option ${OPTOPT}"
       echo -e $usage
       exit 1 ;;
  esac
done
shift $((OPTIND-1))

if [[ $# == 3 ]]; then
  pref=${1}
  target=${2}
  fromcode=${3}
else
  echo "Error: Wrong amount of parameters."
  echo -e $usage
  exit 1
fi

# For explanation of ${tocode:-DEFAULT}, see here:
#   https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
if [[ $verbose == 1 ]]; then
  printf "Converting from: %s\n" $fromcode
  printf "Converting to:   %s\n" ${tocode:-DEFAULT}
  printf "Base path:       %s\n" $pref
  printf "Target path:     %s\n" $target
  printf "Pretend mode:    %u\n" $pretend
fi

if [[ $pretend == 0 ]]; then
  mkdir -p $target
fi

recursive_traversal $pref $target
