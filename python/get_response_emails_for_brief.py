#! /usr/bin/env python

import json
import sys

data = sys.stdin.readlines()
contents = json.loads(''.join(data))

emails = []
for response in contents['briefResponses']:
   emails.append(response['respondToEmailAddress'])

for address in emails:
   print(address)
