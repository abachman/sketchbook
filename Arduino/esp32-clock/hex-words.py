import re, string

minlen = 3

subs = [
    #('for', '4'),
    #('four', '4'),
    #('to', '2'),
    ('ate', '8'),
    #('ten', '10'),
    #('g', '6'),
    ('l', '1'),
    ('o', '0'),
    ('s', '5'),
    ('t', '7')
]

reHexWord = re.compile("[a-f0-9]*")
fWords = open('words.txt', 'r')
for w in fWords.xreadlines():
    w = w.strip()
    for old, new in subs:
        w = string.replace(w, old, new)
    if len(w) >= minlen:
        match = reHexWord.search(w)
        if match and match.group() == w:
            print w

