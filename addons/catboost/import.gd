# MIT License
# 
# Copyright (c) 2020 K. S. Ernest (iFire) Lee & V-Sekai
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@tool
extends EditorScenePostImport


func _post_import(scene):
	_write_test(scene)
	return scene

var catboost = load("res://addons/catboost/catboost.gd")

func _write_test(scene):	
	var old_file = File.new()
	old_file.open(catboost.train_path, File.READ)
	var text = old_file.get_as_text()
	old_file.close()
	var file = File.new()
	file.open(catboost.train_description_path, File.WRITE)
	var init_dict = catboost.bone_create()
	var description : PackedStringArray = init_dict.description
	var file_string : String
	for string in description:
		file_string += string + "\n"
	file.store_string(file_string)
	var file_description = File.new()
	var file_path : String = scene.scene_file_path
	file_path = file_path.get_basename()
	file.open(catboost.train_path, File.WRITE)
	file.store_string(text)
	var vrm_extension = scene
	var bone_map : Dictionary
	var human_map : Dictionary
	if vrm_extension.get("vrm_meta"):
		human_map = vrm_extension["vrm_meta"]["humanoid_bone_mapping"]
	for key in human_map.keys():
		bone_map[human_map[key]] = key
	var queue : Array # Node
	queue.push_back(scene)
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is AnimationPlayer:
			var ap : AnimationPlayer = node
			var anims = node.get_animation_list()
			for anim_i in anims:
				var animation = node.get_animation(anim_i)
				ap.play(animation.resource_name)
				ap.stop(true)
				var anim_length : float = animation.length			
				for track_i in animation.get_track_count():
					var path : String = animation.track_get_path(track_i)
					if str(path).find(":") == -1:
						continue
					var bone_name = path.split(":")[1]
					if not catboost.vrm_humanoid_bones.has(bone_name):
						continue
					var new_path = path.split(":")[0]
					var skeleton_node = scene.get_node(new_path)
					if not skeleton_node is Skeleton3D:
						continue
					var print_skeleton_neighbours_text_cache : Dictionary
					var skeleton : Skeleton3D = skeleton_node
					var fps : int = 5
					var count : int = anim_length * fps
					for count_i in count:
						ap.seek(float(count_i) / fps, true)
						var bone_i = skeleton.find_bone(bone_name)
						var title : String
						var author : String
						var columns_description : PackedStringArray
						var first : bool = true
						var bone : Dictionary = catboost.bone_create().bone
						bone["BONE"] = bone_name
						var neighbours = catboost.skeleton_neighbours(print_skeleton_neighbours_text_cache, skeleton)
						for elem_i in neighbours[bone_i].size():
							if elem_i >= catboost.MAX_HIERARCHY:
								break
							bone["BONE_HIERARCHY_" + str(elem_i).pad_zeros(3)] = skeleton.get_bone_name(neighbours[bone_i][elem_i])
						var bone_rest = skeleton.get_bone_rest(bone_i)
						bone["Bone rest X global origin in meters"] = bone_rest.origin.x
						bone["Bone rest Y global origin in meters"] = bone_rest.origin.x
						bone["Bone rest Z global origin in meters"] = bone_rest.origin.x
						var bone_rest_basis = bone_rest.basis.orthonormalized()
						bone["Bone rest truncated normalized basis axis x 0"] = bone_rest_basis.x.x
						bone["Bone rest truncated normalized basis axis x 1"] = bone_rest_basis.x.y
						bone["Bone rest truncated normalized basis axis x 2"] = bone_rest_basis.x.z
						bone["Bone rest truncated normalized basis axis y 0"] = bone_rest_basis.y.x
						bone["Bone rest truncated normalized basis axis y 1"] = bone_rest_basis.y.y
						bone["Bone rest truncated normalized basis axis y 2"] = bone_rest_basis.y.z
						var bone_rest_scale = bone_rest.basis.get_scale()	
						bone["Bone rest X global scale in meters"] = bone_rest_scale.x
						bone["Bone rest Y global scale in meters"] = bone_rest_scale.y
						bone["Bone rest Z global scale in meters"] = bone_rest_scale.z
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
						bone["ANIMATION_TIME"] = float(count_i) / fps
						bone["Label"] = bone_name
						var bone_parent_key = "BONE_PARENT"
						var parent_bone = skeleton.get_bone_name(bone_parent)
						if not parent_bone.is_empty():
							bone[bone_parent_key] = parent_bone
						var version = vrm_extension["vrm_meta"].get("specVersion")
						if version == null or version.is_empty():
							version = "VERSION_NONE"
						bone["SPECIFICATION_VERSION"] = version
						file.store_csv_line(bone.values(), "\t")
		elif node is Skeleton3D:
			var skeleton : Skeleton3D = node
			var print_skeleton_neighbours_text_cache : Dictionary
			for bone_i in skeleton.get_bone_count():
				var bone : Dictionary = catboost.bone_create().bone
				var bone_rest = skeleton.get_bone_rest(bone_i)
				bone["Bone rest X global origin in meters"] = bone_rest.origin.x
				bone["Bone rest Y global origin in meters"] = bone_rest.origin.x
				bone["Bone rest Z global origin in meters"] = bone_rest.origin.x
				var bone_rest_basis = bone_rest.basis.orthonormalized()
				bone["Bone rest truncated normalized basis axis x 0"] = bone_rest_basis.x.x
				bone["Bone rest truncated normalized basis axis x 1"] = bone_rest_basis.x.y
				bone["Bone rest truncated normalized basis axis x 2"] = bone_rest_basis.x.z
				bone["Bone rest truncated normalized basis axis y 0"] = bone_rest_basis.y.x
				bone["Bone rest truncated normalized basis axis y 1"] = bone_rest_basis.y.y
				bone["Bone rest truncated normalized basis axis y 2"] = bone_rest_basis.y.z
				var bone_rest_scale = bone_rest.basis.get_scale()	
				bone["Bone rest X global scale in meters"] = bone_rest_scale.x
				bone["Bone rest Y global scale in meters"] = bone_rest_scale.y
				bone["Bone rest Z global scale in meters"] = bone_rest_scale.z
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
				if bone["BONE"].is_empty():
					continue
				bone["BONE"] = skeleton.get_bone_name(bone_i)
				var neighbours = catboost.skeleton_neighbours(print_skeleton_neighbours_text_cache, skeleton)
				for elem_i in neighbours[bone_i].size():
					if elem_i >= catboost.MAX_HIERARCHY:
						break
					bone["BONE_HIERARCHY_" + str(elem_i).pad_zeros(3)] = skeleton.get_bone_name(neighbours[bone_i][elem_i])
				var parent_bone = skeleton.get_bone_name(bone_parent)
				if bone_map.has(bone["BONE"]):
					bone["Label"] = bone_map[bone["BONE"]]
				var version = vrm_extension["vrm_meta"].get("specVersion")
				if version == null or version.is_empty():
					version = "1.0"
				bone["SPECIFICATION_VERSION"] = version
				file.store_csv_line(bone.values(), "\t")
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()
	file.close()
