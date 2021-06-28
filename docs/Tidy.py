#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import with_statement
from bs4 import BeautifulSoup
import subprocess as sub
import re
import glob
import sys

repls = [
 (re.compile('^[Mm][Oo][Dd][Ee][Ll][Ii][Cc][Aa]://Modelica/'),'C:/Program Files/OpenModelica1.14.1-64bit/lib/omlibrary/Modelica 3.2.3/'),
 (re.compile('^[Mm][Oo][Dd][Ee][Ll][Ii][Cc][Aa]://ModelicaServices/'),'C:/Program Files/OpenModelica1.14.1-64bit/lib/omlibrary/ModelicaServices 3.2.3/'),
 (re.compile('^[Mm][Oo][Dd][Ee][Ll][Ii][Cc][Aa]://VirtualFCS/'),'C:/Users/simonc/Documents/GitHub/VirtualFCS/VirtualFCS/'),
 (re.compile(r'.*/omlibrary/'), ''),
 (re.compile(r' '), r'%20'),
 (re.compile(r'\''), r'%27'),
 (re.compile(r'[Mm][Oo][Dd][Ee][Ll][Ii][Cc][Aa]://([A-Za-z0-9.\'()_ %]*)#'), r'\1.html#'),
 (re.compile(r'[Mm][Oo][Dd][Ee][Ll][Ii][Cc][Aa]://([A-Za-z0-9.\'()_ %]*)'), r'\1.html'),
]
rehttp = re.compile(r'https?://',flags=re.IGNORECASE)
ignorebookmark = re.compile(r'^([^#]*)#.*')
links = open('tidy.links','w')

def linkreplace(link,filepath):
  result = link
  for (regex,repl) in repls:
    try:
      result = regex.sub(repl,result)
    except:
      pass
  if result is not link and not rehttp.match(result):
    links.write('%s!%s\n' % (filepath,ignorebookmark.sub(r'\1',result)))
  return result

for filepath in sorted(glob.glob('*.html')):
#  sub.call(['cp', filepath, filepath + '.original'])
  tag = '[Checking file %s]:\n' % filepath
#  sys.stdout.write(tag)  # not much point in writing the tags to stdout
  sys.stderr.write(tag)
  pid = sub.call(['tidy', '-utf8', '-modify', '-asxhtml', '--add-xml-decl', 'yes', '-quiet', filepath])
  if pid != 2:
    with open(filepath,'r') as html_file:
      soup = BeautifulSoup(html_file, fromEncoding='utf-8')
      for a in soup.findAll('a'):
        try:
          a['href'] = linkreplace(a['href'],filepath)
        except:
          pass
      for a in soup.findAll('link'):
        try:
          a['href'] = linkreplace(a['href'],filepath)
        except:
          pass
      for img in soup.findAll('img'):
        try:
          img['src'] = linkreplace(img['src'],filepath)
        except:
          pass
    with open(filepath,'w') as html_file:
      html_file.write(str(soup))
  else:
    print('Tidy failed with %s, skipping link-replacement for %s!'  % (pid,filepath))
