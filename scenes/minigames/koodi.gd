extends Node2D

var lines = []
var buttons = []

var wanted_line = []

var actions = ["DPad_Up", "DPad_Right", "DPad_Left", "DPad_Down", 
"Button_X", "Button_A", "Button_Y", "Button_B",  "Shoulder_L", "Shoulder_R"]


func _ready():
	get_lines()
	get_buttons()
	next_wanted_line()

func _process(delta):
	if not wanted_line:
		$CodeBox.delete_old()
		next_wanted_line()


func _input(event):
	for action in actions:
		if event.is_action_pressed(action):
			var b_index = actions.find(action)
			var input_text = buttons[b_index].text
			if input_text == wanted_line[0]:
				wanted_line.remove_at(0)
				print(wanted_line)
			else:
				print("incorrect")


func next_wanted_line():
	var line = lines.pick_random()
	var split_line = separate_words(line)
	print(line, " ", split_line)
	$CodeBox.add_new_text(split_line)
	assign_words_to_buttons(split_line)
	assign_wanted_line(split_line)


func assign_wanted_line(split_line):
	var spec = [" ", ")", "]"]
	for line in split_line:
		if line not in spec:
			wanted_line.append(line)


func assign_words_to_buttons(line):
	var spec = [" ", ")", "]"]
	var indexes = range(0, 10)
	var used = []
	for button in buttons:
		if button.text in line:
			print(button.text, " ", buttons.find(button))
			indexes.erase(buttons.find(button))
			used.append(button.text)
			print(indexes)
	for word in line:
		if word not in spec and word not in used:
			var b_index = indexes.pick_random()
			indexes.erase(b_index)
			buttons[b_index].text = word
			used.append(word)


func get_buttons():
	buttons = $Buttons.get_children()


func separate_words(line):
	var spec = ["_", "(", "-", "=", "[", " ", ")", "]", ","]
	var letters = []
	var true_line = []
	for letter in line:
		if letter not in spec:
			letters.append(letter)
		else:
			if letters:
				var next_line = "".join(letters)
				true_line.append(next_line)
			true_line.append(letter)
			letters = []
	if letters:
		var next_line = "".join(letters)
		true_line.append(next_line)
	return true_line


func get_lines():
	if FileAccess.file_exists("Misc/gitgit.txt"):
		var file = FileAccess.open("Misc/gitgit.txt", FileAccess.READ)
		while file.get_position() < file.get_length():
			var line = file.get_line()
			lines.append(line)
		file.close()
