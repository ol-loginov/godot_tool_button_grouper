@tool
extends EditorPlugin

var inspector

func _enter_tree() -> void:
	var inspector_class = load("res://addons/tool_button_grouper/injector.gd")
	inspector = inspector_class.new()
	add_inspector_plugin(inspector)

func _exit_tree() -> void:
	remove_inspector_plugin(inspector)
