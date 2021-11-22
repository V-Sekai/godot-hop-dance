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

const train_path = "user://train.tsv"
const train_description_path = "user://train_description.txt"
const test_path = "user://test.tsv"
const test_description_path = "user://test_description.txt"
const MAX_HIERARCHY = 256
static func bone_create():
	var bone_category : Dictionary
	var category_description : PackedStringArray
	var label_key = "Label"
	category_description.push_back(str(category_description.size()) + "\t%s" % label_key)
	bone_category[label_key] = "VRM_BONE_NONE"
	var version_key = "SPECIFICATION_VERSION"
	bone_category[version_key] = "1.0"	
	category_description.push_back(str(category_description.size()) + "\tAuxiliary\t%s" % version_key)
	bone_category[version_key] = "1.0"
	var keys = ["BONE"]
	for key_i in keys.size():
		category_description.push_back(str(category_description.size()) + "\tCateg\t%s" % keys[key_i])
		bone_category[keys[key_i]] = ""
	var bone_capitalized_key = "BONE_CAPITALIZED"
	category_description.push_back(str(category_description.size()) + "\tText\t%s" % bone_capitalized_key)
	bone_category[bone_capitalized_key] = "BONE_CAPITAL_NONE"	
	for key_i in MAX_HIERARCHY:
		var hierarchy_key = "BONE_HIERARCHY" + "_" + str(key_i).pad_zeros(3)
		category_description.push_back(str(category_description.size()) + "\tCateg\t%s" % hierarchy_key)
		bone_category[hierarchy_key] = "BONE_NONE"
	bone_category["BONE"] = "BONE_NONE"	
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
