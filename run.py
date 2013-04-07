#!/bin/env python

import glob
import json
import urllib2
import os
import sys

def parseCodefile(filename):
  json_data = open(filename)
  data = json.load(json_data)[0]

  total_codes = data["code_count"]

  code_string = data["code"]
  version = data["metadata"]["version"]
  code = { "version": version, "string": code_string }

  return { "total_codes": total_codes, "code_json": json.dumps(code) }


DIR = os.path.dirname(os.path.realpath(__file__))

query = "http://localhost:37760/query"

input_directory = os.path.join(DIR, sys.argv[1], "codes")

codefiles = glob.glob(os.path.join(input_directory, "4.12", "*.fp"))

count_fail = 0
count_412 = 0
count_413 = 0
count_tied = 0

movie_id = 28

for codefile_412 in codefiles:
  codefile = os.path.basename(codefile_412)
  codefile_413 = os.path.join(input_directory, "4.13", codefile)

  data_412 = parseCodefile(codefile_412)
  data_413 = parseCodefile(codefile_413)

  print ""
  print codefile

  response_412 = urllib2.urlopen(query, data_412["code_json"])
  response_413 = urllib2.urlopen(query, data_413["code_json"])

  response_json_412 = json.load(response_412)
  response_json_413 = json.load(response_413)

  match_id_412 = -1
  match_id_413 = -1

  if "match" in response_json_412:
    match_id_412 = response_json_412["match"]["movie_id"]
    ascore_412 = response_json_412["match"]["ascore"]
    percent_412 = ascore_412 / float(data_412["total_codes"])
    if match_id_412 is not movie_id:
      percent_412 = 0
  else:
    ascore_412 = 0
    percent_412 = 0

  if "match" in response_json_413:
    match_id_413 = response_json_413["match"]["movie_id"]
    ascore_413 = response_json_413["match"]["ascore"]
    percent_413 = ascore_413 / float(data_413["total_codes"])
    if match_id_413 is not movie_id + 2:
      percent_413 = 0
  else:
    ascore_413 = 0
    percent_413 = 0

  print "Matches:", match_id_412, match_id_413
  print "Responses:", response_412.getcode(), ",", response_413.getcode()
  print "Ascores:", ascore_412, ascore_413
  print "Percents:", percent_412, percent_413
  if percent_412 is 0 and percent_413 is 0:
    count_fail += 1
  elif percent_412 > percent_413:
    count_412 += 1
  elif percent_412 < percent_413:
    count_413 += 1
  else:
    count_tied += 1

print ""
print "Summary"
print "4.12:", count_412
print "4.13:", count_413
print "tied:", count_tied
print "failed:", count_fail

