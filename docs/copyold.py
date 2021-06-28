#!/usr/bin/env python
import glob
import os
import shutil
oldtmp = 'old-html-tmp'
if not os.path.exists(oldtmp):
  os.mkdir(oldtmp)
for file in glob.glob('*.html'):
  shutil.copy(file, oldtmp)
