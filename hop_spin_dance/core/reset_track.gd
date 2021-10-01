@tool
extends EditorScenePostImport


func _post_import(scene):
	_bake_animation_pose(scene, "RESET")
	return scene


func _bake_animation_pose(scene : Node, p_bake_anim : String):
	# ASSUME ONLY ONE AP
	var r_rest_bones : Dictionary = {} # StringName, BakeResetRestBone
	var meshes : Array = [] # Node3D
	var queue : Array # Node
	queue.push_back(scene)
	while not queue.is_empty():
		var front = queue.front()
		var node = front
		if node is AnimationPlayer:
			# Step 1: import scene with animations into the rest bones data structure.
			_fetch_reset_animation(node, r_rest_bones, p_bake_anim)

		var child_count : int = node.get_child_count()
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front()

	queue.push_back(scene)
	while not queue.is_empty():
		var node : Node = queue.front();
		if node is Skeleton3D:
			# Step 2: Bake the RESET animation from the RestBone to the skeleton.
			_fix_skeleton(node, r_rest_bones)
		if node is ImporterMeshInstance3D:
			var path : NodePath = node.get_skeleton_path()
			if not path.is_empty() and node.get_node_or_null(path):
				meshes.push_back(node);
		elif node is MeshInstance3D:
			var path : NodePath = node.get_skeleton_path();
			if not path.is_empty() and node.get_node_or_null(path):
				meshes.push_back(node)
		var child_count : int = node.get_child_count();
		for i in child_count:
			queue.push_back(node.get_child(i));
		queue.pop_front()

	queue.push_back(scene);
	while not queue.is_empty():
		var node : Node = queue.front()
		if node is AnimationPlayer:
			# Step 3: Key all RESET animation frames to identity.
			_align_animations(node, r_rest_bones);
		var child_count : int = node.get_child_count();
		for i in child_count:
			queue.push_back(node.get_child(i))
		queue.pop_front();

func _align_animations(p_ap : AnimationPlayer, r_rest_bones : Dictionary) -> void:
	if !p_ap:
		return
	var anim_names : Array = p_ap.get_animation_list();
	for anim_i in anim_names:
		var a : Animation = p_ap.get_animation(anim_i);
		if !a:
			continue
		for rest_bone_i in r_rest_bones.keys():
			var track : int = a.find_track(rest_bone_i);
			if track == -1:
				continue
			var new_track : int = a.add_track(Animation.TYPE_TRANSFORM3D);
			var new_path : NodePath = rest_bone_i;
			var rest_bone = r_rest_bones[rest_bone_i];
			a.track_set_path(new_track, new_path);
			for key_i in a.track_get_key_count(track):
				var time : float = a.track_get_key_time(track, key_i)
				var transform_arr : Array = a.transform_track_interpolate(track, time)
				var loc : Vector3 = transform_arr[0]
				var rot : Quaternion = transform_arr[1]
				var scale : Vector3 = transform_arr[2]
				rot = rot.normalized();
				loc = loc - rest_bone["loc"];
				rot = rest_bone["rest_delta"].get_rotation_quaternion().inverse() * rot;
				rot = rot.normalized();
				scale = Vector3(1, 1, 1) - (rest_bone["rest_delta"].get_scale() - scale);
				# Apply the reverse of the rest changes to make the key be close to identity transform.
				a.transform_track_insert_key(new_track, time, loc, rot, scale);
			a.remove_track(track)
			p_ap.remove_animation(anim_i)
			p_ap.add_animation(anim_i, a)

func _fetch_reset_animation(p_ap : AnimationPlayer, r_rest_bones : Dictionary, p_bake_anim : String) -> void:
	if not p_ap:
		pass
	var anim_names : Array = p_ap.get_animation_list()
	var root : Node = p_ap.get_owner()
	if not root:
		return
	var a : Animation = p_ap.get_animation(p_bake_anim)
	if not a:
		return
	for track in a.get_track_count():
		var path : NodePath = a.track_get_path(track)
		var string_path : String = path
		var skeleton : Skeleton3D = root.get_node(string_path.split(":")[0])
		if !skeleton:
			continue
		var bone_name : String = string_path.split(":")[1]
		for key_i in range(a.track_get_key_count(track)):
			var time : float = 0.0
			var transform_arr : Array = a.transform_track_interpolate(track, time)
			var loc : Vector3 = transform_arr[0]
			var rot : Quaternion = transform_arr[1]
			var scale : Vector3 = transform_arr[2]
			rot = rot.normalized()					
			var rest_bone : Dictionary = {}	
			rest_bone["rest_local"] = Transform3D()
			rest_bone["children"] = PackedInt32Array()
			var rot_basis : Basis = rot
			rot_basis = rot_basis.scaled(scale)
			rest_bone["rest_delta"] = rot_basis
			rest_bone["loc"] = loc
			# Store the animation into the RestBone.
			var new_path : StringName = str(skeleton.get_owner().get_path_to(skeleton)) + ":" + bone_name
			r_rest_bones[new_path] = rest_bone;
			break;

func _fix_skeleton(p_skeleton : Skeleton3D, r_rest_bones : Dictionary) -> void: # Map<StringName, BakeReset::BakeResetRestBone>
	var bone_count : int = p_skeleton.get_bone_count()
	# First iterate through all the bones and update the RestBone.
	for j in bone_count:
		var final_path : StringName = str(p_skeleton.get_owner().get_path_to(p_skeleton)) + ":" + p_skeleton.get_bone_name(j)
		var rest_bone = r_rest_bones[final_path]
		rest_bone.rest_local = p_skeleton.get_bone_rest(j)
	for i in bone_count:
		var parent_bone : int = p_skeleton.get_bone_parent(i)
		var path : NodePath = p_skeleton.get_owner().get_path_to(p_skeleton)
		var final_path : StringName = str(path) + ":" + p_skeleton.get_bone_name(parent_bone)
		if parent_bone >= 0 and r_rest_bones.has(path):
			r_rest_bones[path]["children"].push_back(i)

	# When we apply transform to a bone, we also have to move all of its children in the opposite direction.
	for i in bone_count:
		var final_path : StringName = str(p_skeleton.get_owner().get_path_to(p_skeleton)) + String(":") + p_skeleton.get_bone_name(i)
		r_rest_bones[final_path]["rest_local"] = r_rest_bones[final_path]["rest_local"] * Transform3D(r_rest_bones[final_path]["rest_delta"], r_rest_bones[final_path]["loc"])
		# Iterate through the children and move in the opposite direction.
		for j in r_rest_bones[final_path].children.size():
			var child_index : int = r_rest_bones[final_path].children[j]
			var children_path : StringName = str(p_skeleton.get_name()) + String(":") + p_skeleton.get_bone_name(child_index)
			r_rest_bones[children_path]["rest_local"] = Transform3D(r_rest_bones[final_path]["rest_delta"], r_rest_bones[final_path]["loc"]).affine_inverse() * r_rest_bones[children_path]["rest_local"]

	for i in bone_count:
		var final_path : StringName = str(p_skeleton.get_owner().get_path_to(p_skeleton)) + ":" + p_skeleton.get_bone_name(i)
		if !r_rest_bones.has(final_path):
			continue
		var rest_transform : Transform3D  = r_rest_bones[final_path]["rest_local"]
		p_skeleton.set_bone_rest(i, rest_transform)
