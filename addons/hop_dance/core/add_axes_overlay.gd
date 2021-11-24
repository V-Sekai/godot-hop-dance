@tool
extends EditorScenePostImport


@export
var axes_y : PackedScene = load("res://hop_spin_dance/uiux/axes_indicator/axes_decameter.glb")


func _post_import(scene):
	iterate(scene, scene)
	return scene


func iterate(node, root):
	if node is Skeleton3D:
		var skel : Skeleton3D = node
		for bone_i in range(skel.get_bone_count()):
			var bone_attachment = BoneAttachment3D.new()
			bone_attachment.bone_name = skel.get_bone_name(bone_i)
			var bone_children : Array = skel.get_bone_children(bone_i)
			var axis_y_node : Node3D = axes_y.instantiate()
			bone_attachment.add_child(axis_y_node)			
			axis_y_node.name = bone_attachment.bone_name
			axis_y_node.owner = root
			skel.add_child(bone_attachment)
			bone_attachment.owner = root
			axis_y_node.owner = root
	for child in node.get_children():
		iterate(child, root)
