extends EditorInspectorPlugin

var buttonGroupScene: PackedScene = load('res://addons/tool_button_grouper/button_group.tscn')
var buttonGroup = null
var buttonGroupProperties: Dictionary[String,Variant] = {}


func has_prop_callable(prop: Dictionary) -> bool:
	return prop["type"] == TYPE_CALLABLE
	
func _can_handle(object: Object) -> bool:
	var has_callables: bool = object.get_property_list().find_custom(has_prop_callable.bind()) >= 0
#	print_debug(str(object) + ": has_callables=" + str(has_callables))
	return has_callables
	
	
func _close_button_group() -> void:
	if buttonGroup == null: 
		return

	var names:Array[String] = buttonGroup.get_property_buttons()
#	print_debug("Edit buttons for properties: " + ",".join(names))
	self.add_property_editor_for_multiple_properties("ASD", PackedStringArray(names), buttonGroup)
	buttonGroup = null

func _parse_begin(object: Object) -> void:
#	print_debug("_ParseBegin {@object.GetType().FullName}")
	pass
	
func _parse_end(object: Object) -> void:
#	print_debug("_ParseEnd {@object.GetType().FullName}")
	pass
	
func _parse_category(object: Object, category: String) -> void:
#	print_debug($"_ParseCategory {@object.GetType().FullName}  {category}");
	_close_button_group()
	
	buttonGroupProperties = {}
		
	for dict in object.get_property_list():
		var name:String = dict["name"]
		var type:int = dict["type"]
		if (type == TYPE_CALLABLE):
			buttonGroupProperties[name] = true

func _parse_group(object: Object, group: String) -> void:
	pass
	
func _parse_property(object: Object, type: int, name: String, hint_type: int, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if type == TYPE_CALLABLE:
		if buttonGroup == null:
			buttonGroup = buttonGroupScene.instantiate()
		buttonGroup.add_property_button(name)
		
		buttonGroupProperties.erase(name)
		if buttonGroupProperties.is_empty():
			_close_button_group()
			
		return true
			
	_close_button_group()
	return false
