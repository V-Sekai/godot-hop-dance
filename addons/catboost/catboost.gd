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

static func bone_create():
	var bone_category : Dictionary
	var category_description : PackedStringArray
	var label_key = "Label"
	category_description.push_back(str(category_description.size()) + "\t%s" % label_key)
	bone_category[label_key] = 1
	var keys = ["SPECIFICATION_VERSION", "ANIMATION", "BONE", "BONE_PARENT", "VRM_BONE"
	, "TITLE", "AUTHOR"]
	for key_i in keys.size():
		category_description.push_back(str(1 + key_i) + "\tCateg\t%s" % keys[key_i])
		bone_category[keys[key_i]] = ""
	
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
	bone["Bone parent X global location in meters"] = 0.0
	bone["Bone parent Y global location in meters"] = 0.0
	bone["Bone parent Z global location in meters"] = 0.0
	bone["Bone parent truncated normalized basis axis x 0"] = Basis().x.x
	bone["Bone parent truncated normalized basis axis x 1"] = Basis().x.y
	bone["Bone parent truncated normalized basis axis x 2"] = Basis().x.z
	bone["Bone parent truncated normalized basis axis y 0"] = Basis().y.x
	bone["Bone parent truncated normalized basis axis y 1"] = Basis().y.y
	bone["Bone parent truncated normalized basis axis y 2"] = Basis().y.z
	bone["Bone parent X global scale in meters"] = 1.0
	bone["Bone parent Y global scale in meters"] = 1.0
	bone["Bone parent Z global scale in meters"] = 1.0
	bone["Bone X global location in meters"] = 0.0
	bone["Bone Y global location in meters"] = 0.0
	bone["Bone Z global location in meters"] = 0.0
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
	bone["Bone parent X global location in meters"] = 0.0
	bone["Bone parent Y global location in meters"] = 0.0
	bone["Bone parent Z global location in meters"] = 0.0
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
	bone["Animation time"] = 0.0
	var columns_description : PackedStringArray		
	for key in bone.keys():
		columns_description.push_back(str(bone_category.size() + columns_description.size()) + "\tNum\t%s" % key)
		bone[key] = ""
	for key in bone.keys():
		bone_category[key] = bone[key]
	return {
		"bone": bone_category,
		"description": category_description + columns_description,
	}
