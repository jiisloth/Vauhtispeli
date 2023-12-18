extends Node

var text
var pos
var size 

var wanted_text = ""

var midboxnum = 0

var midboxes = []
var wanted_texts = []
var labels = []

var comp_size = Vector2(0, 0)

var spec = [" ", ")", "]", "-", "_", "(", "[", ",", ".", ":"]

var start = true
var hbox_aligned = false


func _ready():
	pass


func _process(delta):
	pass


func get_new_mid_line():
	wanted_text = wanted_texts.pop_front()
	get_parent().wanted_line = wanted_text


func start_game():
	get_new_mid_line()
	labels = midboxes[0].get_child(0).get_children()
	labels[0].add_theme_color_override("font_color", "#ffff00")


func create_new_midbox(line):
	if midboxes.size() == 6:
		var remove_box = midboxes.pop_front()
		midboxnum -= 1
		remove_box.queue_free()
	var midbox = CenterContainer.new()
	midbox.size = Vector2(1874, 100)
	midbox.position.y = 500
	add_child(midbox)
	var hbox = HBoxContainer.new()
	midbox.add_child(hbox)
	midboxes.append(midbox)
	add_new_text(line, hbox)
	move_midboxes()
	midboxnum += 1


func move_midboxes():
	for midbox in midboxes:
		midbox.position.y -= 100


func correct_choice(cor_line):
	var cor_found = false
	var bracket = 0
	var yellow = false
	var removed_labels = []
	for label in labels:
		if cor_found:
			if label.text in spec:
				if not yellow:
					label.add_theme_color_override("font_color", "#00db00")
				if label.text == "(" or label.text == "[":
					bracket += 1
				elif bracket and (label.text == ")" or label.text == "]"):
					if bracket == 1:
						label.add_theme_color_override("font_color", "#00db00")
					else:
						bracket -= 1
			elif wanted_text:
				if label.text == wanted_text[0] and not yellow:
					label.add_theme_color_override("font_color", "#ffff00")
					yellow = true
					if bracket == 0:
						break
		elif label.text == cor_line:
			label.add_theme_color_override("font_color", "#00db00")
			cor_found = true
			removed_labels.append(label)
		else:
			removed_labels.append(label)
	for label in removed_labels:
		labels.erase(label)


func wrong_choice(cor_line):
	for label in labels:
		if label.text == cor_line:
			label.add_theme_color_override("font_color", "#ff0000")
			break


func delete_old():
	labels = midboxes[midboxnum-3].get_child(0).get_children()
	labels[0].add_theme_color_override("font_color", "#ffff00")


func add_new_text(line, hbox):
	text = line
	var wanted_line = []
	for word in line:
		if word not in spec:
			wanted_line.append(word)
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 50)
		label.text = word
		hbox.add_child(label)
	wanted_texts.append(wanted_line)


func change_hbox_placement(hbox):
	comp_size = Vector2(0, 0)
	for child in hbox.get_children():
		comp_size += child.size
	hbox.position.x = abs(comp_size.x - get_viewport().size.x)/2
	hbox.position.y = 250
	hbox_aligned = true
