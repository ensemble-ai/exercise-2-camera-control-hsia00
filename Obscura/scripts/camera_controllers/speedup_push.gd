class_name SpeedupPush
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-15, -15)
@export var pushbox_bottom_right: Vector2 = Vector2(15, 15)
@export var speedup_zone_top_left: Vector2 = Vector2(-10, -10)
@export var speedup_zone_bottom_right: Vector2 = Vector2(10, 10)

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# Check if target is inside speedup zone
	var inside_speedup_zone = tpos.x > speedup_zone_top_left.x && \
			tpos.x < speedup_zone_bottom_right.x && \
			tpos.z > speedup_zone_top_left.y && \
			tpos.z < speedup_zone_bottom_right.y
	
	# If inside speedup zone do nothing
	if inside_speedup_zone:
		return
	
	# Check if target is inside pushbox
	var inside_pushbox = tpos.x > pushbox_top_left.x && \
			tpos.x < pushbox_bottom_right.x && \
			tpos.z > pushbox_top_left.y && \
			tpos.z < pushbox_bottom_right.y
			
	#if inside_pushbox:
		

	
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# Calculate screen boundary corners with margins
	var pushbox_left = pushbox_top_left.x
	var pushbox_right = pushbox_bottom_right.x
	var pushbox_top = pushbox_top_left.y
	var pushbox_bottom = pushbox_bottom_right.y
	var speedup_zone_left = speedup_zone_top_left.x
	var speedup_zone_right = speedup_zone_bottom_right.x
	var speedup_zone_top = speedup_zone_top_left.y
	var speedup_zone_bottom = speedup_zone_bottom_right.y
	
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
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_top))

	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_bottom))

	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_bottom))

	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
