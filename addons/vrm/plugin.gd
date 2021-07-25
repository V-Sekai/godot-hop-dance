@tool
extends EditorPlugin

var import_plugin
var script = load("res://addons/vrm/import_vrm.gd")

func _enter_tree():
	import_plugin = script.new()
	add_scene_import_plugin(import_plugin)


func _exit_tree():
	remove_scene_import_plugin(import_plugin)
	import_plugin = null
