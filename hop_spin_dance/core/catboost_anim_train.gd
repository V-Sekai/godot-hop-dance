@tool
extends EditorScenePostImport

func _post_import(scene):
	_write_test(scene, false)
	return scene
	
func _write_test(scene, write_column_description):	
	var file = File.new()
	file.open("user://train.tsv", File.READ)
	var train : String = file.get_as_text()
	file.close()
	var current_file = File.new()
	current_file.open("user://train.tsv", File.WRITE)
	current_file.store_string(train)
	var queue : Array # Node
	queue.push_back(scene)
	var skeletons : Dictionary
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is AnimationPlayer:
			var ap : AnimationPlayer = node
			var anims = node.get_animation_list()
			for anim_i in anims:
				var animation = node.get_animation(anim_i)
				var anim_length : float = animation.length
				for track_i in animation.get_track_count():
					var path : String = animation.track_get_path(track_i)
					if str(path).find(":") == -1:
						continue
					var bone_name = path.split(":")[1]
					var new_path = path.split(":")[0]
					var skeleton_node = scene.get_node(new_path)
					if skeleton_node is Skeleton3D:
						var skeleton : Skeleton3D = skeleton_node
						var skel : Array
						skel.resize(skeleton.get_bone_count())
						var fps : int = 60
						var count : int = anim_length * fps
						for count_i in count:
							ap.seek(count_i / fps, true)
							var bone_i = skeleton.find_bone(bone_name)
							var title : String
							var author : String
							var columns_description : PackedStringArray
							var first : bool = true
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
							bone["Animation Time"] = float(count_i) / fps
							if first:
								var keys = bone.keys()
								for key_i in range(keys.size()):
									columns_description.push_back(str(key_i) + "\tNum\t" + keys[key_i])
							# Text categories
							var title_key = "Title"
							if first:
								columns_description.push_back(str(columns_description.size()) + "\tCateg\t%s" % title_key)
							bone["Title"] = ""
							var author_key = "Author"
							if first:
								columns_description.push_back(str(columns_description.size()) + "\tCateg\t%s" % author_key)
							bone[author_key] = ""
							
							var name_key = "Bone Name"
							if first:
								columns_description.push_back(str(columns_description.size()) + "\tCateg\t%s" % name_key)
							bone[name_key] = bone_name
							
							var bone_parent_key = "Bone Parent"
							if first:
								columns_description.push_back(str(columns_description.size()) + "\tCateg\t%s" % bone_parent_key)
							var parent_bone = skeleton.get_bone_name(bone_parent)
							if parent_bone.is_empty():
								parent_bone = 0
							bone[bone_parent_key] = parent_bone

							var vrm_bone_name_key = "Corresponding VRM Bone"
							if first:
								columns_description.push_back(str(bone.keys().size()) + "\tLabel")
							bone[vrm_bone_name_key] = 0
							var version_key = "Specification Version"
							if first:
								columns_description.push_back(str(bone.keys().size()) + "\tCateg\t%s" % version_key)
							bone[version_key] = 0
							var animation_key = "Animation"
							if first:
								columns_description.push_back(str(bone.keys().size()) + "\tCateg\t%s" % animation_key)
							bone[animation_key] = animation.resource_name
							if first:
								first = false
							if write_column_description:
								var file_cd = File.new()
								file_cd.open("user://cd.txt", File.WRITE)
								var file_string : String
								for string in columns_description:
									file_string += string + "\n"
								file_cd.store_string(file_string)
								file_cd.close()
							var header : Array
							current_file.store_csv_line(bone.values(), "\t")
			break
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()		

	current_file.close()
	return scene
