import sys
import re

reload(sys)
sys.setdefaultencoding('ascii')

f = open(sys.argv[1], 'r').read()

replace = []

def repl(matchobj):
	replace.append([matchobj.group(1), matchobj.group(2)])
	return ''

def include(matchobj):
	return open(matchobj.group(1), 'r').read()

f = re.sub(r'#include \"([^\"]+)\".*(?=\n)', include, f)
f = re.sub(r'#replace \"(.+)\", \"(.*)\".*\n', repl, f)
for pair in replace:
	# print pair
	f = re.sub(pair[0], pair[1], f)
print f