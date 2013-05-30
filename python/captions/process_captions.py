#! /usr/bin/env python
import os, re
from optparse import OptionParser

def add_spaces(str, spaces):
  """
    Indent the sent string by the number of spaces set
    Returns string.
  """
  for idx in range(spaces):
    str = " " + str;
  return str

if __name__ == "__main__":
  # assumes .sbv files are in the same directory as this script
  cwd = os.getcwd()
  captionblocks = []
  block = {
    'text' : ''
  }
  filenames = [
    {  "key" : "input", "default" : "captions.sbv", "flag" : "-i" },
    {  "key" : "output", "default" : "captions.xml", "flag" : "-o" },
    {  "key" : "begin", "default" : "captions_header.xml", "flag" : "-s" },
    {  "key" : "end", "default" : "captions_footer.xml", "flag" : "-e" }
  ]
  parser = OptionParser()

  for item in filenames:
    parser.add_option(item["flag"], "--" + item["key"], dest=item["key"] + "_file", default=item["default"])

  (options, args) = parser.parse_args()

  input_file = open(os.path.join(cwd, options.input_file), 'r')
  output_file = open(os.path.join(cwd, options.output_file), 'w')
  caption_header = open(os.path.join(cwd, options.begin_file), 'r')
  caption_footer = open(os.path.join(cwd, options.end_file), 'r')

  # parse .sbv file
  for line in input_file:
    endofblock = re.search('^$', line)
    time_units = re.search('^([\d]+):([\d]+):([\d]+)\.(?:[\d]+),([\d]+):([\d]+):([\d]+)\.(?:[\d]+)$', line)
    
    if endofblock:
      block['text'] = block['text'].rstrip()
      captionblocks.append(block)
      # reset block
      block = {
          'text' : ''
      }
    elif time_units:
      time = list(time_units.groups())
      if len(time[0]) < 2: time[0] = '0' + time[0] 
      if len(time[3]) < 2: time[3] = '0' + time[3] 
      block['time'] = {
        'begin' : "%s:%s:%s" % tuple(time[:3]),
        'end' : "%s:%s:%s" % tuple(time[3:])
      }
    else:
      block['text'] += line.replace("\n", " ")

  print "number of captions: " + str(len(captionblocks))

  # write results to .ttml file
  output_file.write(caption_header.read())

  for cap in captionblocks:
    caption_line = add_spaces("<p begin=\"%s\" end=\"%s\">%s</p>\n" % (cap['time']['begin'], cap['time']['end'], cap['text']), 6)
    output_file.write(caption_line)

  output_file.write(caption_footer.read())
