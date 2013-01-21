import re

file_input = open('input.txt', 'r').read()
words_list = re.findall(r"\w+(?:'\w+)?", file_input)


punctuation_list = re.findall(r'[^\w\s]', file_input)

words_list.sort()
words_list.sort(key=str.lower)
punctuation_list.sort()


output_file = open('alphabetical.txt', 'w')
for word in words_list:
	print>>output_file, word

for word in punctuation_list:
	print>>output_file, word

output_file.close()

output_file = open('frequency.txt', 'w')
total_list = words_list  # + punctuation_list

counted_list = []
last_word = ''
new_list = []
for word in total_list:
	if (word.lower() != last_word):
		counted_list.append(new_list)
		new_list = []
	new_list.append(word)
	last_word = word.lower()

counted_list.sort(key=lambda s: len(s), reverse=True)
for words in counted_list:
	for word in words:
		print>>output_file, word

output_file.close()
