@tool
extends EditorScenePostImport

var vrm_bone_definition : PackedStringArray  = ["hips","leftUpperLeg","rightUpperLeg","leftLowerLeg","rightLowerLeg","leftFoot","rightFoot",
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

func _post_import(scene):
	_write_test(scene)
	return scene

var catboost = load("res://addons/catboost/catboost.gd")

func _write_test(scene):
	var file = File.new()
	file.open(catboost.train_path, File.WRITE)
	file.close()
	var train : String = file.get_as_text()
	file.open(catboost.train_description_path, File.WRITE)
	var init_dict = catboost.bone_create()
	var description = init_dict.description
	file.store_string(description)
	var file_description = File.new()
	file.open(catboost.train_path, File.WRITE)
	file.store_csv_line(init_dict.bone.keys(), "\t")
	file.store_string(train)
	var queue : Array # Node
	queue.push_back(scene)
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is Skeleton3D:
			var skeleton : Skeleton3D = node
			var skel : Array
			skel.resize(skeleton.get_bone_count())
			var columns_description : PackedStringArray
			var first : bool = true
			for bone_i in skeleton.get_bone_count():
				var bone : Dictionary = init_dict.bone
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
				bone["Animation Time"] = 0.0
				if first:
					var keys = bone.keys()
					for key_i in range(keys.size()):
						columns_description.push_back(str(key_i) + "\tNum\t" + keys[key_i])
				bone["Bone"] = skeleton.get_bone_name(bone_i)
				var parent_bone = skeleton.get_bone_name(bone_parent)
				if not parent_bone.is_empty():
					bone["Bone Parent"] = parent_bone
				if vrm_bone_definition.has(skeleton.get_bone_name(bone_i)):
					bone["VRM bone"] = skeleton.get_bone_name(bone_i)
				else:
					bone["VRM bone"] = "hips"
				bone["Specification version"] = ""
				bone["Animation"] = "T-Pose"
				skel[bone_i] = bone
			if skel.size():
				for bone in skel:
					file.store_csv_line(bone.values(), "\t")
		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()
	file.close()
	return scene
