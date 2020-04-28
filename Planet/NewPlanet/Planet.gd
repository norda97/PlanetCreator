extends Spatial


var phi = 0.0
var orbitSpeed = randf() / 10
var axisRotateSpeed = 0.1

var minor_axis = 10
var major_axis = 10
var position

var xArrow
var zArrow

var gotCamera = false
var offset
var cameraHolder
var camera
var unPos
var shouldOrbit
var orbitMesh
var vertexCount = 20



func _ready():
	_randomizeName()
	cameraHolder = get_tree().current_scene.get_node("CameraHolderMaster")
	shouldOrbit = false
	
	createArrows()
	
	self.position = Vector3(cos(phi) * major_axis, 0.0, sin(phi) * minor_axis)

func createArrows():
	xArrow = createArrow(Color.red)
	zArrow = createArrow(Color.blue)
	
	xArrow.name = "xArrow"
	zArrow.name = "zArrow"
	
	# Set to parent arrows to ignore planet scale inheritance
	var node = Node.new()
	node.name = "Orbit Arrows"
	node.add_child(xArrow)
	node.add_child(zArrow)
	
	self.add_child(node)
	
func createArrow(color, scale = 0.2):
	var arrowMat = SpatialMaterial.new()
	arrowMat.albedo_color = color
	arrowMat.flags_unshaded = true
	
	var collisionShape = CollisionShape.new()
	collisionShape.shape = SphereShape.new()
	collisionShape.disabled = true
	
	var arrow = MeshInstance.new()
	arrow.mesh = SphereMesh.new()
	arrow.material_override = arrowMat
	
	arrow.set_scale(Vector3(scale, scale, scale))
	arrow.set_as_toplevel(true)
	arrow.visible = false
	
	var boundingArea = StaticBody.new()
	boundingArea.input_ray_pickable = false
	boundingArea.add_child(collisionShape)

	arrow.add_child(boundingArea)
	
	return arrow

func _randomizeName():
	var planetName = "X-"
	planetName += String(randi() % 1000)
	self.name = planetName

func orbit(dt):
	phi += orbitSpeed * dt
	position.x = cos(phi) * major_axis
	position.z = sin(phi) * minor_axis
	self.translation = position

func shouldPlanetOrbit(state):
	shouldOrbit = state
	pass

onready var mdt = MeshDataTool.new()
onready var sf = SurfaceTool.new()
func updateOrbitLines():
	createOribitLines(vertexCount)
	
	pass

#func createOrbitArrows():
#	var arrowMat = SpatialMaterial.new()
#	var collisionShape
#	arrowMat.albedo_color = Color.red
#	xArrow = MeshInstance.new()
#	xArrow.name = "xArrow"
#	var boundingArea = StaticBody.new()
#	boundingArea.input_ray_pickable = true
#	collisionShape = CollisionShape.new()
#	collisionShape.shape = SphereShape.new()
#	boundingArea.add_child(collisionShape)
#	xArrow.add_child(boundingArea)
#	xArrow.mesh = SphereMesh.new()
#	xArrow.material_override = arrowMat
#	xArrow.name = "xArrow"
#	xArrow.mesh.radius = 0.2
#	xArrow.mesh.height = 0.4
#	xArrow.set_as_toplevel(true)
#	self.add_child(xArrow)
#	xArrow.visible = false
#
#	arrowMat = SpatialMaterial.new()
#	arrowMat.albedo_color = Color.blue
#	zArrow = MeshInstance.new()
#	zArrow.name = "xArrow"
#	boundingArea = StaticBody.new()
#	boundingArea.input_ray_pickable = true
#	collisionShape = CollisionShape.new()
#	collisionShape.shape = SphereShape.new()
#	boundingArea.add_child(collisionShape)
#	zArrow.add_child(boundingArea)
#	zArrow.mesh = SphereMesh.new()
#	zArrow.material_override = arrowMat
#	zArrow.name = "zArrow"
#	zArrow.mesh.radius = 0.2
#	zArrow.mesh.height = 0.4
#	zArrow.set_as_toplevel(true)
#	self.add_child(zArrow)

func makeOrbitArrowVisible(isVisible):
	xArrow.visible = isVisible
	xArrow.get_child(0).input_ray_pickable = isVisible
	xArrow.get_child(0).get_child(0).disabled = !isVisible
	
	zArrow.visible = isVisible
	zArrow.get_child(0).input_ray_pickable = isVisible
	zArrow.get_child(0).get_child(0).disabled = !isVisible
	
func createOribitLines(vertexCount):
	sf = SurfaceTool.new()
	sf.begin(Mesh.PRIMITIVE_LINE_LOOP)
	
	var angle = 0
	var rad = ((2*PI) / vertexCount)
	var vPos = Vector3(0, 0, 0)
	for i in vertexCount:
		vPos.x = cos(angle) * major_axis
		vPos.z = sin(angle) * minor_axis
		if i == 0:
			xArrow.translation = Vector3(vPos.x + 1, 0, vPos.z)
		elif i == vertexCount/4:
			zArrow.translation  = Vector3(vPos.x, 0, vPos.z + 1)
		sf.add_vertex(vPos)
		angle += rad
	
	
	if !orbitMesh:
		orbitMesh = MeshInstance.new()
		orbitMesh.mesh = sf.commit()
		
		var mat = SpatialMaterial.new()
		mat.albedo_color = Color.white
		mat.albedo_color.a = 0.1
		mat.flags_transparent = true
		mat.flags_unshaded = true
		orbitMesh.material_override = mat
		
		var node = Node.new()
		node.name = "orbitMeshNode"
		node.add_child(orbitMesh)
		self.add_child(node)
	else:
		orbitMesh.mesh.surface_remove(0)
		sf.commit(orbitMesh.mesh)

func rotatePlanet(relative):
	self.rotate_y(relative[0] * 0.05)
	pass

func _process(dt):
	if shouldOrbit:
		self.rotate_y(PI * axisRotateSpeed * dt)
		self.orbit(dt)
#	if cameraHolder:
	#   camera = cameraHolder.getCurrentCamera() #fett ooptimerat, fixa
	#	unPos = camera.unproject_position(self.global_transform.origin)
	#	if camera.global_transform.origin.dot(self.global_transform.origin) > 0:
	#		nameLabel.visible = false
	#	else:
	#		nameLabel.visible = true
	#
	#	nameLabel.set_position(unPos - offset)
#	self.rotate_y(PI * axisRotateSpeed * dt)
#	camera = cameraHolder.getCurrentCamera() #fett ooptimerat, fixa
#	unPos = camera.unproject_position(self.global_transform.origin)
#	if camera.global_transform.origin.dot(self.global_transform.origin) > 0:
#		nameLabel.visible = false
#	else:
#		nameLabel.visible = true
#
#	nameLabel.set_position(unPos - offset)
	pass
