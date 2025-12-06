@tool
extends EditorProperty

var property_buttons:Dictionary[String, Button] = {}

func _enter_tree() -> void:
	draw_label = false

func get_property_buttons() -> Array[String]:
	return property_buttons.keys()
	
func add_property_button(name:String) -> void:
	var flow: HFlowContainer = self.find_child("Root")

	var container:MarginContainer = MarginContainer.new()
	container.add_theme_constant_override("margin_top", 4);
	container.add_theme_constant_override("margin_bottom", 4);
	container.add_theme_constant_override("margin_left", 4);
	container.add_theme_constant_override("margin_right", 4);
	flow.add_child(container)
	
	var button :Button = Button.new()
	button.pressed.connect(_on_button_pressed.bind(name))
	container.add_child(button)
	
	property_buttons.set(name, button)

func _on_button_pressed(name:String) -> void :
	var callable:Callable = get_edited_object().get(name)  
	callable.call()

func _update_property() -> void:
	label = ''
	for name in property_buttons.keys():
		_refresh_control_text(name,property_buttons[name])

func has_prop_name(prop: Dictionary, name:String) -> bool:
	return name == (prop["name"] as String)
		
func _refresh_control_text(name:String,button:Button) -> void:
	var prop_list: Array[Dictionary] = get_edited_object().get_property_list()
	var prop_index: int = get_edited_object().get_property_list().find_custom(has_prop_name.bind(name))
	
#	print_debug(prop_list[prop_index])
	
	var hint :Variant = null
	if prop_index >= 0:
		hint = prop_list[prop_index]["hint_string"] as String
#		print_debug("hint from hint_string is: " + hint)
	
	if hint == null:
		hint = get_edited_property() as String
		
	var icon:String = "";
	var icon_pos = hint.find(',') 
	if  icon_pos > 0:
		icon = hint.substr(icon_pos  + 1)
		hint = hint.substr(0,icon_pos)
	
	if !icon.is_empty():
		button.icon = get_theme_icon(icon, "EditorIcons")
	button.text = hint	
