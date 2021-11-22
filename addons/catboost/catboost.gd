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

extends RefCounted

const vrm_humanoid_bones = ["hips","leftUpperLeg","rightUpperLeg","leftLowerLeg","rightLowerLeg","leftFoot","rightFoot",
 "spine","chest","neck","head","leftShoulder","rightShoulder","leftUpperArm","rightUpperArm",
 "leftLowerArm","rightLowerArm","leftHand","rightHand","leftToes","rightToes","leftEye","rightEye","jaw",
 "leftThumbProximal","leftThumbIntermediate","leftThumbDistal",
 "leftIndexProximal","leftIndexIntermediate","leftIndexDistal",
 "leftMiddleProximal","leftMiddleIntermediate","leftMiddleDistal",
 "leftRingProximal","leftRingIntermediate","leftRingDistal",
 "leftLittleProximal","leftLittleIntermediate","leftLittleDistal",
 "rightThumbProximal","rightThumbIntermediate","rightThumbDistal",
 "rightIndexProximal","rightIndexIntermediate","rightIndexDistal",
 "rightMiddleProximal","rightMiddleIntermediate","rightMiddleDistal",
 "rightRingProximal","rightRingIntermediate","rightRingDistal",
 "rightLittleProximal","rightLittleIntermediate","rightLittleDistal", "upperChest"]

const MAX_HIERARCHY = 256
var CATBOOST_KEYS = [
		["Label", "\t%s", "VRM_BONE_NONE"],
		["BONE", "\tCateg\t%s", "BONE_NONE"], 
		["BONE_CAPITALIZED", "\tAuxiliary\t%s", "BONE_NONE"],
		["SPECIFICATION_VERSION", "\tAuxiliary\t%s", "VERSION_NONE"],
		["ANIMATION_TIME", "\tAuxiliary\t%s", 0.0],
	]	
static func bone_create():
	var bone_category : Dictionary
	var category_description : PackedStringArray
	
	for key_i in MAX_HIERARCHY:
		CATBOOST_KEYS.push_back(["\tCateg\t%s", "BONE_HIERARCHY" + "_" + str(key_i).pad_zeros(3), "BONE_NONE"])
	for key_i in CATBOOST_KEYS.size():
		category_description.push_back(str(category_description.size()) + CATBOOST_KEYS[key_i][1] % CATBOOST_KEYS[key_i][0])
		bone_category[CATBOOST_KEYS[key_i]] = CATBOOST_KEYS[key_i][2]
	var bone : Dictionary
	bone["Bone rest X global origin in meters"] = 0.0
	bone["Bone rest Y global origin in meters"] = 0.0
	bone["Bone rest Z global origin in meters"] = 0.0
	bone["Bone rest truncated normalized basis axis x 0"] = Basis().x.x
	bone["Bone rest truncated normalized basis axis x 1"] = Basis().x.y
	bone["Bone rest truncated normalized basis axis x 2"] = Basis().x.z
	bone["Bone rest truncated normalized basis axis y 0"] = Basis().y.x
	bone["Bone rest truncated normalized basis axis y 1"] = Basis().y.y
	bone["Bone rest truncated normalized basis axis y 2"] = Basis().y.z	
	bone["Bone rest X global scale in meters"] = 1.0
	bone["Bone rest Y global scale in meters"] = 1.0
	bone["Bone rest Z global scale in meters"] = 1.0
	bone["Bone X global origin in meters"] = 0.0
	bone["Bone Y global origin in meters"] = 0.0
	bone["Bone Z global origin in meters"] = 0.0
	bone["Bone truncated normalized basis axis x 0"] = Basis().x.x
	bone["Bone truncated normalized basis axis x 1"] = Basis().x.y
	bone["Bone truncated normalized basis axis x 2"] = Basis().x.z
	bone["Bone truncated normalized basis axis y 0"] = Basis().y.x
	bone["Bone truncated normalized basis axis y 1"] = Basis().y.y
	bone["Bone truncated normalized basis axis y 2"] = Basis().y.z	
	bone["Bone X global scale in meters"] = 1.0
	bone["Bone Y global scale in meters"] = 1.0
	bone["Bone Z global scale in meters"] = 1.0
	bone["Bone parent X global origin in meters"] = 0.0
	bone["Bone parent Y global origin in meters"] = 0.0
	bone["Bone parent Z global origin in meters"] = 0.0
	bone["Bone parent truncated normalized basis axis x 0"] = Basis().x.x
	bone["Bone parent truncated normalized basis axis x 1"] = Basis().x.y
	bone["Bone parent truncated normalized basis axis x 2"] = Basis().x.z
	bone["Bone parent truncated normalized basis axis y 0"] = Basis().y.x
	bone["Bone parent truncated normalized basis axis y 1"] = Basis().y.y
	bone["Bone parent truncated normalized basis axis y 2"] = Basis().y.z
	bone["Bone parent X global scale in meters"] = 1.0
	bone["Bone parent Y global scale in meters"] = 1.0
	bone["Bone parent Z global scale in meters"] = 1.0
	bone["Bone X global origin in meters"] = 0.0
	bone["Bone Y global origin in meters"] = 0.0
	bone["Bone Z global origin in meters"] = 0.0
	var basis : Basis
	bone["Bone truncated normalized basis axis x 0"] = basis.x.x
	bone["Bone truncated normalized basis axis x 1"] = basis.x.y
	bone["Bone truncated normalized basis axis x 2"] = basis.x.z
	bone["Bone truncated normalized basis axis y 0"] = basis.y.x
	bone["Bone truncated normalized basis axis y 1"] = basis.y.y
	bone["Bone truncated normalized basis axis y 2"] = basis.y.z
	var scale : Vector3 = Vector3(1.0, 1.0, 1.0)
	bone["Bone X global scale in meters"] = scale.x
	bone["Bone Y global scale in meters"] = scale.y
	bone["Bone Z global scale in meters"] = scale.z
	bone["Bone parent X global origin in meters"] = 0.0
	bone["Bone parent Y global origin in meters"] = 0.0
	bone["Bone parent Z global origin in meters"] = 0.0
	var parent_basis : Basis
	bone["Bone parent truncated normalized basis axis x 0"] = parent_basis.x.x
	bone["Bone parent truncated normalized basis axis x 1"] = parent_basis.x.y
	bone["Bone parent truncated normalized basis axis x 2"] = parent_basis.x.z
	bone["Bone parent truncated normalized basis axis y 0"] = parent_basis.y.x
	bone["Bone parent truncated normalized basis axis y 1"] = parent_basis.y.y
	bone["Bone parent truncated normalized basis axis y 2"] = parent_basis.y.z
	bone["Bone parent X global scale in meters"] = 1.0
	bone["Bone parent Y global scale in meters"] = 1.0
	bone["Bone parent Z global scale in meters"] = 1.0
	var columns_description : PackedStringArray		
	for key in bone.keys():
		columns_description.push_back(str(bone_category.size() + columns_description.size()) + "\tNum\t%s" % key)
	for key in bone.keys():
		bone_category[key] = bone[key]
	return {
		"bone": bone_category,
		"description": category_description + columns_description,
	}

static func write_import(scene, is_test):
	var description_path = "user://train_description.txt"
	var file = File.new()
	var text = ""
	var do_path = "user://train.tsv"
	if not is_test:
		var old_file = File.new()
		file.open(do_path, File.READ)
		text = old_file.get_as_text()
		file.close()
	if is_test:
		description_path = "user://test_description.txt"
		do_path = "user://test.tsv"
	file.open(do_path, File.WRITE)
	file.store_string(text)
	file.open(description_path, File.WRITE)
	var init_dict = bone_create()
	var description : PackedStringArray = init_dict.description
	var file_string : String
	for string in description:
		file_string += string + "\n"
	file.store_string(file_string)
	var file_description = File.new()
	var file_path : String = scene.scene_file_path
	file_path = file_path.get_basename()
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
				if animation != null:
					continue
				ap.play(animation.resource_name)
				ap.stop(true)
				var anim_length : float = animation.length			
				for track_i in animation.get_track_count():
					var path : String = animation.track_get_path(track_i)
					if str(path).find(":") == -1:
						continue
					var bone_name = path.split(":")[1]
					if not bone_map.has(bone_name):
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
						if not bone_map.has(bone_name):
							continue
						ap.seek(float(count_i) / fps, true)
						var bone_i = skeleton.find_bone(bone_name)
						var title : String
						var author : String
						var columns_description : PackedStringArray
						var first : bool = true
						var bone : Dictionary = bone_create().bone
						bone["BONE"] = bone_name
						bone["BONE_CAPITALIZED"] = bone["BONE"].capitalize()
						var neighbours = skeleton_neighbours(print_skeleton_neighbours_text_cache, skeleton)
						for elem_i in neighbours[bone_i].size():
							if elem_i >= MAX_HIERARCHY:
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
				var bone : Dictionary = bone_create().bone
				if bone_map.has(bone["BONE"]):
					bone["Label"] = bone_map[skeleton.get_bone_name(bone_i)]
				bone["BONE"] = skeleton.get_bone_name(bone_i)
				if not bone_map.has(bone["BONE"] ):
					continue
				bone["BONE_CAPITALIZED"] = bone["BONE"].capitalize()
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
				var neighbours = skeleton_neighbours(print_skeleton_neighbours_text_cache, skeleton)
				for elem_i in neighbours[bone_i].size():
					if elem_i >= MAX_HIERARCHY:
						break
					bone["BONE_HIERARCHY_" + str(elem_i).pad_zeros(3)] = skeleton.get_bone_name(neighbours[bone_i][elem_i])
				var parent_bone = skeleton.get_bone_name(bone_parent)
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


static func skeleton_neighbours(skeleton_neighbours_cache : Dictionary, skeleton):
	if skeleton_neighbours_cache.has(skeleton):
		return skeleton_neighbours_cache[skeleton]
	var bone_list_text : String
	var parents : PackedFloat32Array
	for bone_i in skeleton.get_bone_count():
		var bone_global_pose = skeleton.get_bone_global_pose(bone_i)
		var origin = bone_global_pose.origin
		parents.push_back(origin.distance_to(Vector3(0, 0, 0)))
	var neighbor_list = find_neighbor_joint(parents, 2.0)
	if neighbor_list.size() == 0:
		return [].duplicate()
	skeleton_neighbours_cache[skeleton] = neighbor_list
	return neighbor_list


static func find_neighbor_joint(parents, threshold):
# The code in find_neighbor_joint(parents, threshold) is adapted
# from deep-motion-editing by kfiraberman, PeizhuoLi and HalfSummer11.
	var n_joint = parents.size()
	var dist_mat : PackedFloat32Array
	dist_mat.resize(n_joint * n_joint)
	for i in parents.size():
		var p = parents[i]
		if i != 0:
			var result = 1
			dist_mat[p * i + 1] = result
			dist_mat[i * p + p] = dist_mat[p * i + 1]
#   Floyd's algorithm
	for k in range(n_joint):
		for i in range(n_joint):
			for j in range(n_joint):
				dist_mat[i * j + j] = min(dist_mat[i * j + j], dist_mat[i * k + k] + dist_mat[k * j + j])

	var neighbor_list : Array = [].duplicate()
	for i in range(n_joint):
		var neighbor = [].duplicate()
		for j in range(n_joint):
			if dist_mat[i * j + j] <= threshold:
				neighbor.append(j)
		neighbor_list.append(neighbor)
	return neighbor_list
