@tool
extends EditorScenePostImport


func _post_import(scene):
	_move_animation_path(scene)
	return scene
	
func _move_animation_path(scene):
	var queue : Array # Node
	queue.push_back(scene)
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is AnimationPlayer:
			var anims = node.get_animation_list()
			for anim_i in anims:
				var animation = node.get_animation(anim_i)
				for track_i in animation.get_track_count():
					var path : String = animation.track_get_path(track_i)
					var splits = path.split("/", true, 1)
					if splits.size() > 1:
						path = path.split("/", true, 1)[1]
						animation.track_set_path(track_i, path)
		elif node is Skeleton3D:
			node.free()
			break
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()		

	return scene
