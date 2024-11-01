class_name SpeedupPush
extends CameraControllerBase

@export var push_ratio: float = 0.6
@export var pushbox_top_left: Vector2 = Vector2(-12, -12)
@export var pushbox_bottom_right: Vector2 = Vector2(12, 12)
@export var speedup_zone_top_left: Vector2 = Vector2(-5, -5)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5, 5)

var switched:= false
var pushed:= false

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		switched = false
		return

	if draw_camera_logic:
		draw_logic()
		
	# Set start location as current target location
	if !switched:
		global_position.x = target.global_position.x
		global_position.z = target.global_position.z
		switched = true
	
	var tpos = target.global_position
	var cpos = global_position
	
	# Calculate boundaries of pushbox and speedup zone
	var pushbox_left = cpos.x + pushbox_top_left.x
	var pushbox_right = cpos.x + pushbox_bottom_right.x
	var pushbox_top = cpos.z + pushbox_top_left.y
	var pushbox_bottom = cpos.z + pushbox_bottom_right.y
	var speedup_left = cpos.x + speedup_zone_top_left.x
	var speedup_right = cpos.x + speedup_zone_bottom_right.x
	var speedup_top = cpos.z + speedup_zone_top_left.y
	var speedup_bottom = cpos.z + speedup_zone_bottom_right.y
	
	# Check if target is inside speedup zone
	var inside_speedup_zone: bool = tpos.x > speedup_left && \
			tpos.x < speedup_right && tpos.z > speedup_top && \
			tpos.z < speedup_bottom
	
	# If inside speedup zone do nothing
	if inside_speedup_zone:
		pushed = false
	
	else:	
		# Check if target is inside pushbox (and not inside speedup zone)	
		var inside_pushbox: bool = tpos.x > pushbox_left && \
				tpos.x < pushbox_right && tpos.z > pushbox_top && \
				tpos.z < pushbox_bottom
		# Check if target is touching pushbox sides
		var touching_left: bool = tpos.x - target.WIDTH / 2.0 <= pushbox_left
		var touching_right: bool = tpos.x + target.WIDTH / 2.0 >= pushbox_right
		var touching_top: bool = tpos.z - target.WIDTH / 2.0 <= pushbox_top
		var touching_bottom: bool = tpos.z + target.WIDTH / 2.0 >= pushbox_bottom
		# Check if target is pushing pushbox side
		var pushing_only_left: bool = touching_left && target.velocity.x < 0
		var pushing_only_right: bool = touching_right && target.velocity.x > 0
		var pushing_only_top: bool = touching_top && target.velocity.z < 0
		var pushing_only_bottom: bool = touching_bottom && target.velocity.z > 0
		var pushing_top_left: bool = touching_left && touching_top && \
				(target.velocity.x < 0 || target.velocity.y < 0)
		var pushing_bottom_left: bool = touching_left && touching_bottom && \
				(target.velocity.x < 0 || target.velocity.y > 0)
		var pushing_top_right: bool = touching_right && touching_top && \
				(target.velocity.x > 0 || target.velocity.y < 0)
		var pushing_bottom_right: bool = touching_right && touching_bottom && \
				(target.velocity.x > 0 || target.velocity.y > 0)
		var pushing: bool = pushing_top_left || pushing_bottom_left || pushing_top_right || \
				pushing_bottom_right || pushing_only_left || pushing_only_right || \
				pushing_only_top || pushing_only_bottom
				
		if inside_pushbox && !pushed:
			global_position.x += target.velocity.x * push_ratio * delta
			global_position.z += target.velocity.z * push_ratio * delta
			
		elif pushing:
			pushed = true
			# Pushing at a corner
			if pushing_top_left || pushing_bottom_left || pushing_top_right || pushing_bottom_right:
				# Move fully in x and z
				global_position.x += target.velocity.x * delta
				global_position.z += target.velocity.z * delta
			
			# Pushing at sides (x)
			elif touching_left && target.velocity.x < 0 || touching_right && target.velocity.x > 0:
				# Move fully in x and scaled by push_ratio in z
				global_position.x += target.velocity.x * delta
				global_position.z += target.velocity.z * push_ratio * delta
			
			# Pushing at sides (z)
			elif touching_top && target.velocity.z < 0 || touching_bottom && target.velocity.z > 0:
				# Move fully in z and scaled by push_ratio in x
				global_position.x += target.velocity.x * push_ratio * delta
				global_position.z += target.velocity.z * delta
		else:
			# If pushed, target moves freely
			pass
	
	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var pushbox_left = pushbox_top_left.x
	var pushbox_right = pushbox_bottom_right.x
	var pushbox_top = pushbox_top_left.y
	var pushbox_bottom = pushbox_bottom_right.y
	var speedup_left = speedup_zone_top_left.x
	var speedup_right = speedup_zone_bottom_right.x
	var speedup_top = speedup_zone_top_left.y
	var speedup_bottom = speedup_zone_bottom_right.y
	print(pushbox_left)
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Draw lines between the corners to form a rectangle for pushbox
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_top))

	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_bottom))

	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_bottom))

	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_top))
	
	# Draw lines between the corners to form a rectangle for speedup zone
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))

	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))

	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))

	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
