import subprocess
import re

with open("frequency.txt") as f:
	words = f.readlines()

pattern = re.compile('[\W_]+')
lastWord = ''
filename = ''
for word in words:
	if (lastWord != word.lower()):
		lastWord = filename = word.lower()
		filename = pattern.sub('', filename) + ".wav"
		subprocess.call(['C:\Program Files (x86)\eSpeak\command_line\espeak', "-w " + filename, word])


#subprocess.call(['C:\Program Files (x86)\eSpeak\command_line\espeak', "-w file.wav", "Definitely."])
