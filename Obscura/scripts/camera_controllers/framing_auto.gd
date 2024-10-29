class_name FramingAuto
extends CameraControllerBase

@export var scroll_speed: float = 2.0 
@export var box_width:float = dist_above_target * 20
@export var box_height:float = dist_above_target * 20
@export var margin: Vector2 = Vector2(100, 100)

var screen_size

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	screen_size = get_viewport().size
	#print(screen_size)
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	global_position.x += scroll_speed * delta
	
	# Set target position within the camera boundaries
	# Calculate the screen boundary limits with margins
	var min_x = margin.x
	var max_x = screen_size.x - margin.x
	var min_z = margin.y
	var max_z = screen_size.y - margin.y
	
	# Convert the target's world position to screen coordinates
	var screen_position = unproject_position(tpos)
	print(screen_position)
	# Check if target is outside the screen boundaries
	if screen_position.x <= min_x:
		global_position.x -= min_x - screen_position.x
	elif screen_position.x >= max_x:
		global_position.x += screen_position.x - max_x

	if screen_position.y <= min_z:
		global_position.z -= min_z - screen_position.y
	elif screen_position.y >= max_z:
		global_position.z += screen_position.y - max_z
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Calculate screen boundary corners with margins
	var left = margin.x
	var right = screen_size.x - margin.x
	var top = margin.y
	var bottom = screen_size.y - margin.y

	# Draw lines between the corners to form a rectangle
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))

	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))

	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
