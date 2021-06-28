#!/usr/bin/env python
# Finds files *.html that have the same case-insensitive names and renames one or more of them
# Example: Ab.html AB.html ab.html becomes: Ab.1.html ab.2.html AB.html

import glob
import os
import re

def getFiles():
  files = sorted([f for f in glob.glob('*.html') if os.path.isfile(f)], key=str.lower)
  return files

def update(subst):
  for file in glob.glob('*.html'):
    if os.path.isfile(file):
      with open (file, 'r' ) as f: orig = f.read()
      patched = orig
      for s in subst.items():
        patched = re.sub('\\b'+s[0],s[1],patched)
      if patched is not orig:
        with open (file, 'w' ) as f: f.write(patched)
  return

def makeCaseSensitive():
  files = getFiles()
  last = ''
  idx = 0
  repls = {}
  for file in files:
    upper = file.upper()
    if upper == last:
      while True:
        idx += 1
        nfile = file.split('.')
        nfile.insert(len(nfile)-1,str(idx))
        nfile = '.'.join(nfile)
        if not os.path.isfile(nfile):
          print('Renaming file %s to %s' % (file,nfile))
          repls[file] = nfile
          os.rename(file, nfile)
          break
    else:
      idx = 0
    last = upper
  return repls

print('Running Python script: makeCaseSensitive')
repls = makeCaseSensitive()
update(repls)
