@tool
extends EditorPlugin

var editor_interface: EditorInterface = null


func _init():
	print("Initialising VSKVersion plugin")


func _notification(p_notification: int):
	match p_notification:
		NOTIFICATION_PREDELETE:
			print("Destroying VSKVersion plugin")


func get_name() -> String:
	return "VSKVersion"


func _enter_tree() -> void:
	editor_interface = get_editor_interface()
	
	if ! Engine.is_editor_hint():
		add_autoload_singleton("VSKVersion", "res://addons/vsk_version/vsk_version.gd")


func _exit_tree() -> void:
	if ! Engine.is_editor_hint():
		remove_autoload_singleton("res://addons/vsk_version/vsk_version.gd")
