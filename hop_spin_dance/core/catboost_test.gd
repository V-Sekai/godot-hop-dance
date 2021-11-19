@tool
extends EditorScenePostImport


func _post_import(scene):
	_write_test(scene)
	return scene
	
func _write_test(scene):
	var queue : Array # Node
	queue.push_back(scene)
	while not queue.is_empty():
		var front = queue.front()
		var node = front
#		if node is AnimationPlayer:
#			var anims = node.get_animation_list()
#			for anim_i in anims:
#				var animation = node.get_animation(anim_i)
#				for track_i in animation.get_track_count():
#					var path : String = animation.track_get_path(track_i)
#					var splits = path.split("/", true, 1)
#					if splits.size() > 1:
#						path = path.split("/", true, 1)[1]
#						animation.track_set_path(track_i, path)
		if node is Skeleton3D:
			var skeleton : Skeleton3D = node
			var title : String
			var author : String
			var skel : Array
			skel.resize(skeleton.get_bone_count())
			var columns_description : PackedStringArray
			var first : bool = true
			for bone_i in skeleton.get_bone_count():		
				var bone : Dictionary
				bone["Bone X global location in meters"] = 0.0
				bone["Bone Y global location in meters"] = 0.0
				bone["Bone Z global location in meters"] = 0.0
				bone["Bone truncated normalized basis axis x 0"] = Basis().x.x
				bone["Bone truncated normalized basis axis x 1"] = Basis().x.y
				bone["Bone truncated normalized basis axis x 2"] = Basis().x.z
				bone["Bone truncated normalized basis axis y 0"] = Basis().y.x
				bone["Bone truncated normalized basis axis y 1"] = Basis().y.y
				bone["Bone truncated normalized basis axis y 2"] = Basis().y.z	
				bone["Bone X global scale in meters"] = 1.0
				bone["Bone Y global scale in meters"] = 1.0
				bone["Bone Z global scale in meters"] = 1.0
				bone["Bone Parent X global location in meters"] = 0.0
				bone["Bone Parent Y global location in meters"] = 0.0
				bone["Bone Parent Z global location in meters"] = 0.0
				bone["Bone Parent truncated normalized basis axis x 0"] = Basis().x.x
				bone["Bone Parent truncated normalized basis axis x 1"] = Basis().x.y
				bone["Bone Parent truncated normalized basis axis x 2"] = Basis().x.z
				bone["Bone Parent truncated normalized basis axis y 0"] = Basis().y.x
				bone["Bone Parent truncated normalized basis axis y 1"] = Basis().y.y
				bone["Bone Parent truncated normalized basis axis y 2"] = Basis().y.z
				bone["Bone Parent X global scale in meters"] = 0.0
				bone["Bone Parent Y global scale in meters"] = 0.0
				bone["Bone Parent Z global scale in meters"] = 0.0
				var bone_pose = skeleton.get_bone_global_pose(bone_i)
				bone["Bone X global location in meters"] = bone_pose.origin.x
				bone["Bone Y global location in meters"] = bone_pose.origin.y
				bone["Bone Z global location in meters"] = bone_pose.origin.z
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
					bone["Bone Parent X global location in meters"] = bone_pose.origin.x
					bone["Bone Parent Y global location in meters"] = bone_pose.origin.y
					bone["Bone Parent Z global location in meters"] = bone_pose.origin.z
					var parent_basis = bone_parent_pose.basis.orthonormalized()
					bone["Bone Parent truncated normalized basis axis x 0"] = parent_basis.x.x
					bone["Bone Parent truncated normalized basis axis x 1"] = parent_basis.x.y
					bone["Bone Parent truncated normalized basis axis x 2"] = parent_basis.x.z
					bone["Bone Parent truncated normalized basis axis y 0"] = parent_basis.y.x
					bone["Bone Parent truncated normalized basis axis y 1"] = parent_basis.y.y
					bone["Bone Parent truncated normalized basis axis y 2"] = parent_basis.y.z
					var parent_scale = bone_parent_pose.basis.get_scale()
					bone["Bone Parent X global scale in meters"] = parent_scale.x
					bone["Bone Parent Y global scale in meters"] = parent_scale.y
					bone["Bone Parent Z global scale in meters"] = parent_scale.z
				bone["Masculine (-1.0) and feminine (1.0)"] = 0.0
				bone["Body mass in kilograms"] = 0.0
				bone["Head circumference in meters"] = 0.0
				bone["Neckline circumference in meters"] = 0.0
				bone["Left Shoulder circumference in meters"] = 0.0
				bone["Right Shoulder circumference in meters"] = 0.0
				bone["Left Elbow circumference in meters"] = 0.0
				bone["Right Elbow circumference in meters"] = 0.0
				bone["Left wrist circumference in meters"] = 0.0
				bone["Right wrist circumference in meters"] = 0.0
				bone["Waist circumference in meters"] = 0.0
				bone["Left thigh circumference in meters"] = 0.0
				bone["Right thigh circumference in meters"] = 0.0
				bone["Left ankle circumference in meters"] = 0.0
				bone["Right ankle circumference in meters"] = 0.0
				bone["Animation Time"] = 0.0
				if first:
					var keys = bone.keys()
					for key_i in range(keys.size()):
						columns_description.push_back(str(key_i) + "\tNum\t" + keys[key_i])
				# Text categories
				var title_key = "Title"
				if first:
					columns_description.push_back(str(columns_description.size()) + "\tText\t%s" % title_key)
				bone["Title"] = title_key
				var author_key = "Author"
				if first:
					columns_description.push_back(str(columns_description.size()) + "\tText\t%s" % author_key)
				bone[author_key] = author
				
				var name_key = "Bone Name"
				if first:
					columns_description.push_back(str(columns_description.size()) + "\tText\t%s" % name_key)
				bone[name_key] = skeleton.get_bone_name(bone_i)
				
				var bone_parent_key = "Bone Parent"
				if first:
					columns_description.push_back(str(columns_description.size()) + "\tText\t%s" % bone_parent_key)
				var parent_bone = skeleton.get_bone_name(bone_parent)
				if parent_bone.is_empty():
					parent_bone = ""
				bone[bone_parent_key] = parent_bone
				
				var vrm_bone_name_key = "Corresponding VRM Bone"
				if first:
					columns_description.push_back(str(bone.keys().size()) + "\tLabel")
				bone[vrm_bone_name_key] = "UNKNOWN"
				var version_key = "Specification Version"
				if first:
					columns_description.push_back(str(bone.keys().size()) + "\tText\t%s" % version_key)
				bone[version_key] = ""
				var animation_key = "Animation"
				if first:
					columns_description.push_back(str(bone.keys().size()) + "\tText\t%s" % animation_key)
				bone[animation_key] = "T-Pose"
				if first:
					first = false
				skel[bone_i] = bone
			var file_cd = File.new()
			file_cd.open("user://cd.txt", File.WRITE)
			var file_string : String
			for string in columns_description:
				file_string += string + "\n"
			file_cd.store_string(file_string)
			file_cd.close()
			var header : Array
			var current_file = File.new()
			current_file.open("user://test.tsv", File.WRITE)
			if skel.size():
				for bone in skel:
					current_file.store_csv_line(bone.values(), "\t")
			current_file.close()

			
			break
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()		

	return scene
