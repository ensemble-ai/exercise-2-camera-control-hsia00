class_name FramingAuto
extends CameraControllerBase

@export var top_left: Vector2 = Vector2(-12, -6)
@export var bottom_right: Vector2 = Vector2(12, 6)
@export var autoscroll_speed: Vector3 = Vector3(20, 0, 0)

var switched:= false
var screen_size: Vector2

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		switched = false
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# Set autoscroll start location as current target location
	if current && !switched:
		global_position.x = target.global_position.x
		global_position.z = target.global_position.z
		switched = true
	
	# Camera autoscroll
	if current:
		global_position.x += autoscroll_speed.x * delta
		global_position.z += autoscroll_speed.z * delta
		target.global_position.x += autoscroll_speed.x * delta
		target.global_position.z += autoscroll_speed.z * delta
		tpos = target.global_position
	
	# Set target position within the camera boundaries
	var left_bound = cpos.x + top_left.x + target.WIDTH / 2.0
	var right_bound = cpos.x + bottom_right.x - target.WIDTH / 2.0
	var top_bound = cpos.z + top_left.y + target.WIDTH / 2.0
	var bottom_bound = cpos.z + bottom_right.y - target.WIDTH / 2.0
	
	# Constrain target within the camera bounds in x and z directions
	target.global_position.x = clamp(tpos.x, left_bound, right_bound)
	target.global_position.z = clamp(tpos.z, top_bound, bottom_bound)
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Calculate screen boundary corners with margins
	var left = top_left.x
	var right = bottom_right.x
	var top = top_left.y
	var bottom = bottom_right.y

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
