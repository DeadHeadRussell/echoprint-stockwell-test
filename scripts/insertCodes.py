#!/bin/env python

import glob
import json
import os
import urllib2
import sys

DIR = os.path.dirname(os.path.realpath(__file__))

insert = "http://localhost:37760/insert"

input_directory = os.path.join(DIR, "..", sys.argv[1])
codefiles = glob.glob(os.path.join(input_directory, "codes", "*", "*.fp"))

for codefile in codefiles:
  json_data = open(codefile)
  data = json.load(json_data)[0]
  json_data.close()

  code_string = data["code"]
  version = data["metadata"]["version"]
  name = os.path.basename(codefile)
  length = 0
  movie = { "name": name, "length": 0, "codes": { "version": version, "string": code_string } }

  print ""
  print codefile
  response = urllib2.urlopen(insert, json.dumps(movie))
  print "Response: ", response.getcode()
  print response.read()

