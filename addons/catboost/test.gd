@tool
extends EditorScenePostImport

func _post_import(scene):
	_write_test(scene)
	return scene

var catboost = load("res://addons/catboost/catboost.gd")

func _write_test(scene):
	var file = File.new()
	file.open(catboost.test_description_path, File.WRITE)
	var init_dict = catboost.bone_create()
	var description : PackedStringArray = init_dict.description
	var file_string : String
	for string in description:
		file_string += string + "\n"
	file.store_string(file_string)
	file.close()
	file.open(catboost.test_path, File.WRITE)
	file.store_csv_line(init_dict.bone.keys(), "\t")
	# NO CHEATING ANSWERS
	var vrm_extension = scene
	var queue : Array # Node
	queue.push_back(scene)
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is Skeleton3D:
			var skeleton : Skeleton3D = node
			var skel : Array
			skel.resize(skeleton.get_bone_count())
			for bone_i in skeleton.get_bone_count():
				var bone : Dictionary = init_dict.bone
				var bone_pose = skeleton.get_bone_global_pose(bone_i)
				bone["Bone X global origin in meters"] = bone_pose.origin.x
				bone["Bone Y global origin in meters"] = bone_pose.origin.y
				bone["Bone Z global origin in meters"] = bone_pose.origin.z
				var basis = bone_pose.basis.orthonormalized()
				bone["Bone truncated normalized basis axis x 0"] = basis.x.x
				bone["Bone truncated normalized basis axis x 1"] = basis.x.y
				bone["Bone truncated normalized basis axis x 2"] = basis.x.z
				bone["Bone truncated normalized basis axis y 0"] = basis.y.x
				bone["Bone truncated normalized basis axis y 1"] = basis.y.y
				bone["Bone truncated normalized basis axis y 2"] = basis.y.z
				var scale = bone_pose.basis.get_scale()
				bone["Bone X global scale in meters"] = scale.x
				bone["Bone Y global scale in meters"] = scale.y
				bone["Bone Z global scale in meters"] = scale.z
				var bone_parent = skeleton.get_bone_parent(bone_i)
				if bone_parent != -1:
					var bone_parent_pose = skeleton.get_bone_global_pose(bone_parent)
					bone["Bone parent X global origin in meters"] = bone_pose.origin.x
					bone["Bone parent Y global origin in meters"] = bone_pose.origin.y
					bone["Bone parent Z global origin in meters"] = bone_pose.origin.z
					var parent_basis = bone_parent_pose.basis.orthonormalized()
					bone["Bone parent truncated normalized basis axis x 0"] = parent_basis.x.x
					bone["Bone parent truncated normalized basis axis x 1"] = parent_basis.x.y
					bone["Bone parent truncated normalized basis axis x 2"] = parent_basis.x.z
					bone["Bone parent truncated normalized basis axis y 0"] = parent_basis.y.x
					bone["Bone parent truncated normalized basis axis y 1"] = parent_basis.y.y
					bone["Bone parent truncated normalized basis axis y 2"] = parent_basis.y.z
					var parent_scale = bone_parent_pose.basis.get_scale()
					bone["Bone parent X global scale in meters"] = parent_scale.x
					bone["Bone parent Y global scale in meters"] = parent_scale.y
					bone["Bone parent Z global scale in meters"] = parent_scale.z
				bone["BONE"] = skeleton.get_bone_name(bone_i)
				# Assume wrong answers are correct
				if bone_parent != -1:
					var parent_bone = skeleton.get_bone_name(bone_parent)
					if not parent_bone.is_empty():
						bone["BONE_PARENT"] = parent_bone
				else:
					bone["BONE_PARENT"] = bone["BONE"]
				var version = "VERSION_NONE"
				if vrm_extension.get("vrm_meta"):
					vrm_extension["vrm_meta"].get("specVersion")
				bone["SPECIFICATION_VERSION"] = version
				file.store_csv_line(bone.values(), "\t")
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()
	file.close()
