#!/bin/bash
rm -f *.png *.pdf FindFiles.log*
touch FindFiles.log.tmp
OMLIBRARY="C:/Program Files/OpenModelica1.14.1-64bit//lib/omlibrary"
for f in `sort -u tidy.links`; do
  link=`echo $f | cut '-d!' -f2-`
  link=`python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])" "$link"`
  if test -f "$OMLIBRARY/$link"; then
    d=`dirname "$link"`
    mkdir -p "$d"
    cp "$OMLIBRARY/$link" "$link"
  elif test -f "$link"; then
    true
  else
    inFile=`echo $f | cut '-d!' -f1`
    inLib=`echo $inFile | cut '-d.' -f1`
    echo "$inLib $inFile: Not found: $link" | tee -a FindFiles.log.tmp
  fi
done
# Sort on library, then remove the library
sort FindFiles.log.tmp | cut -d' ' -f2- > FindFiles.log
rm -f tmp FindFiles.log.tmp
