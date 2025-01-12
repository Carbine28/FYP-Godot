extends Panel

onready var _button = $"../../../ButtonPanel/MarginContainer/HBoxContainer/codeButton"
onready var _GUI = $"../../../../"
onready var _codeContainer = $"padding/VBoxContainer/codeContainer"
onready var _matrixPanel = $padding/VBoxContainer/MatrixPanel

var blockStack: Array
var object
var codeStack: Array

func _on_codeButton_pressed():
	if not visible:
		_button.text = "Hide Code"
		set_code()
		show()
	else:
		_button.text = "Show Code"
		hide()
		clear_code()

func set_code():
	blockStack = _GUI.blockStack
	
	if blockStack:
		object = _GUI.selectedObject
		_matrixPanel.update_matrix(object)
		var line = Label.new()
		line.autowrap = true
		line.text = " // First create Identity Matrix\nmat4 mMatrix = mat4(1.0f)\n\n"
		line.text += "// Transformation code goes here"
		_codeContainer.add_child(line)
		for block in blockStack:
			line = Label.new()
			line.autowrap = true
			
			match block.label:
				"Translate":
					var string = "translate(mMatrix, vec3(%s, %s, %s))"
					var formatted_string = string % [block.x_Value, block.y_Value, block.z_Value]
					line.text += formatted_string
				"Rotate":
					var string
					match block.inputOption:
#						0:
#							string = "glm::rotate(modelMatrix, glm::radians(%s), glm::vec3(1.0f, 0.0f, 0.0f))"
#						1:
#							string = "glm::rotate(modelMatrix, glm::radians(%s), glm::vec3(0.0f, 1.0f, 0.0f))"
#						2:
#							string = "glm::rotate(modelMatrix, glm::radians(%s), glm::vec3(0.0f, 0.0f, 1.0f))"
						0:
							string = "rotate(mMatrix, radians(%s), vec3(1.0f, 0.0f, 0.0f))"
						1:
							string = "rotate(mMatrix, radians(%s), vec3(0.0f, 1.0f, 0.0f))"
						2:
							string = "rotate(mMatrix, radians(%s), vec3(0.0f, 0.0f, 1.0f))"
					var formatted_string = string % [block.inputValue]
					line.text += formatted_string
					print(line.name)
				"Scale":
					var string = "scale(mMatrix, glm::vec3(%s, %s, %s))"
					var formatted_string = string % [block.inputValue, block.inputValue, block.inputValue]
					line.text += formatted_string
			codeStack.push_back(line)
#			print(codeStack)
			_codeContainer.add_child(line)
	else:
		var line = Label.new()
		line.autowrap = true
		line.text = "Drag some blocks into the drawing area to get started!"
		_codeContainer.add_child(line)
		
func print_matrix():
	pass
	
func clear_code():
	for child in _codeContainer.get_children():
		child.queue_free()
	codeStack.clear()
	_button.text = "Show Code"
		
func _on_codePanel_hide():
	clear_code()

func _on_TransformableGUI_action_executed():
	if visible:
		clear_code()
	set_code()
	codeStack.front().add_color_override("font_color", Color(0,1,0,1))
	show()

func _on_TransformableGUI_next_action_executed():
	codeStack.front().add_color_override("font_color", Color(1,1,1,1))
	codeStack.pop_front()
	codeStack.front().add_color_override("font_color", Color(0,1,0,1))


func _on_TransformableGUI_selected_object_cleared():
	_matrixPanel.clear_matrix()
