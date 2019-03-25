import re


_regexp = r'[(](.*?)[)]'
import re
v = '${P(data.csv)}'
ab = re.findall(_regexp, v)[0]
print(ab)