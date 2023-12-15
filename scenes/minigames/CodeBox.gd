extends Node

var text
var wanted_text
var pos
var size 
var hbox

var hbox_aligned = false

var labels = []

func _ready():
	hbox = HBoxContainer.new()
	add_child(hbox)


func _process(delta):
	if not hbox_aligned:
		change_hbox_placement()


func delete_old():
	for child in hbox.get_children():
		child.queue_free()


func add_new_text(line):
	text = line
	wanted_text = line
	for word in line:
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 50)
		label.text = word
		labels.append(label)
		hbox.add_child(label)
	hbox_aligned = false

func change_hbox_placement():
	var comp_size = Vector2(0, 0)
	for child in hbox.get_children():
		print(child.size)
		comp_size += child.size
	print(comp_size, " ", get_viewport().size)
	hbox.position.x = abs(comp_size.x - get_viewport().size.x)/2
	hbox.position.y = 250
	print(hbox.position)
	hbox_aligned = true
