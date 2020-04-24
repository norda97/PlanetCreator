extends Node

var ray

var cameraHolder
var selected

# Called when the node enters the scene tree for the first time.
func _ready():
	# Retrive camera
	cameraHolder = get_tree().current_scene.get_node("CameraHolderMaster")
	if !cameraHolder:
		print("Failed to retrive cameraHolder for \"PlanetMover.gd\" on node: ", self.name)
	pass # Replace with function body.


func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			# Get essential data for raycast
			var camera = cameraHolder.getCurrentCamera()
			var viewport = get_viewport()
			var mousePos = viewport.get_mouse_position()
			
			# Project ray
			var rayOrigin = camera.project_ray_origin(mousePos)
			var rayDir = camera.project_ray_normal(mousePos)
			var rayDist = 1000
			
			var from = rayOrigin
			var to = rayOrigin + rayDir * rayDist
			var spaceState = viewport.get_world().get_direct_space_state()
			var hit = spaceState.intersect_ray(from, to)
			if hit.size() != 0:
				# collider will be the node you hit
				selected = hit.collider.get_parent()
		
		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			if selected:
				selected = null
				print("Released planet")
	
	if selected:
		if event is InputEventMouseMotion:
			var relative = event.get_relative() * 0.1
			
			selected.minor_axis += relative.y
			selected.major_axis += relative.x
			selected.updateOrbitLines()
			