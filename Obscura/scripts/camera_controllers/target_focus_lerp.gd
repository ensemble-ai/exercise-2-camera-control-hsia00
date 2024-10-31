class_name TargetFocusLerp
extends CameraControllerBase

@export var lead_speed: float = 40.0
@export var catchup_delay_duration: float = 0.5
@export var catchup_speed: float = 5.0
@export var leash_distance: float = 25.0
@export var crosshair_length:float = 5.0

var switched:= false

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
	var distance_to_target = tpos.distance_to(cpos)
	
	if !switched:
		global_position.x = target.global_position.x
		global_position.z = target.global_position.z
		switched = true
	
	# Determine speed based on target's movement status
	if target.velocity == Vector3.ZERO:
		# Smoothly approach the target within the leash range
		print("catch")
		global_position.x = lerp(cpos.x, tpos.x, catchup_speed * delta)
		global_position.z = lerp(cpos.z, tpos.z, catchup_speed * delta)
	# If target moving
	else:
		var at_leash = abs(distance_to_target - leash_distance) <= 1.0
		if !at_leash:
			print("lookahead")
			var desired_position = tpos + target.velocity * lead_speed * delta
			global_position = lerp(tpos, desired_position, lead_speed * delta)
		else:
			print("leash")
			global_position.x += target.velocity.x * delta
			global_position.z += target.velocity.z * delta
		
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Horizontal line
	immediate_mesh.surface_add_vertex(Vector3(-crosshair_length, 0, 0))  # Left
	immediate_mesh.surface_add_vertex(Vector3(crosshair_length, 0, 0))   # Right

	# Vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -crosshair_length))  # Top
	immediate_mesh.surface_add_vertex(Vector3(0, 0, crosshair_length))   # Bottom
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
