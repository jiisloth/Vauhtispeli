extends Node2D

var lines = []
var words = []
var buttons = []
var wanted_line = []
var last_used_lines = []

var score = 0

var actions = ["DPad_Up", "DPad_Right", "DPad_Left", "DPad_Down", 
"Shoulder_L", "Shoulder_R", "Button_X", "Button_A", "Button_Y", "Button_B"]
var spec = [" ", ")", "]", "-", "_", "(", "[", ",", ".", ":"]


func _ready():
	get_lines()
	get_words()
	buttons = $Buttons.get_child(0).get_children()
	for i in range(3):
		next_wanted_line()
	$CodeBox.start_game()
	assign_words_to_buttons()
	print(wanted_line)
	
	

func _process(delta):
	if not wanted_line:
		score += 5
		next_wanted_line()
		$CodeBox.get_new_mid_line()
		$CodeBox.delete_old()
		assign_words_to_buttons()
	$ScoreLabel.text = "Score: " + str(score)


func _input(event):
	for action in actions:
		if event.is_action_pressed(action):
			var b_index = actions.find(action)
			var input_text = buttons[b_index].text
			buttons[b_index].get_child(0).frame = 1
			if input_text == wanted_line[0]:
				var cor = wanted_line.pop_front()
				score += 2
				$CodeBox.correct_choice(cor)
			else:
				score -= 1
				var cor = wanted_line[0]
				$CodeBox.wrong_choice(cor)
		elif event.is_action_released(action):
			var b_index = actions.find(action)
			buttons[b_index].get_child(0).frame = 0


func get_words():
	for line in lines:
		for word in line:
			if word not in spec and word not in words:
				words.append(word)


func next_wanted_line():
	var available_lines = lines
	var line = available_lines.pick_random()
	while line in last_used_lines:
		available_lines.erase(line)
		line = available_lines.pick_random()
	last_used_lines.append(line)
	if last_used_lines.size() == 5:
		last_used_lines.pop_front()
	$CodeBox.create_new_midbox(line)


func assign_words_to_buttons():
	var indexes = range(0, 10)
	var used = []
	var available_words = words.duplicate()
	for line in wanted_line:
		if line not in used:
			var b_index = indexes.pick_random()
			indexes.erase(b_index)
			buttons[b_index].text = line
			used.append(line)
			available_words.erase(line)
	for b_index in indexes:
		if buttons[b_index].text not in wanted_line:
			var nu_word = available_words.pick_random()
			available_words.erase(nu_word)
			print(buttons[b_index].text)
			buttons[b_index].text = nu_word


func separate_words(line):
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
			var split_line = separate_words(line)
			lines.append(split_line)
		file.close()


func _on_timer_timeout():
	score -= 1
