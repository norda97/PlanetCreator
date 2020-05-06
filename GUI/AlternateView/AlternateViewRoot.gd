extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var hBoxContainer = get_node("ScrollContainer/HBoxContainer")
onready var window = self
onready var planetsInScene = get_parent().get_parent().get_parent().get_child(0)
onready var environment = get_parent().get_parent().get_parent().get_node("WorldEnvironment")
onready var rayScript = load("res://GUI/AlternateView/ViewportRayCast.gd")
var namePanel
var hoveredViewPortContainer
var planetsInView = []
var cameras = []
var nameLabel
var sizeLabel
var viewPortContainers = []
var viewPorts = []
onready var nameEdit = get_node("NamePanel/HBoxContainer/LineEdit")

var nameDic = {}
var sizeDic = {}
var camDic = {}
# Called when the node enters the scene tree for the first time.
func _ready():
#	hBoxContainer.set_as_toplevel(true)
#	hBoxContainer.set_h_size_flags(3)
	window.visible = false
	namePanel = get_node("NamePanel")
	for i in range(planetsInScene.get_child_count()):
		var viewPortContainer = ViewportContainer.new()
		viewPortContainer.stretch = true
		viewPortContainer.set_h_size_flags(3) #Expand horizontal
		viewPortContainer.set_v_size_flags(3)
		viewPortContainer.rect_min_size = Vector2(128,128)
		viewPortContainer.connect("mouse_entered", self, "_on_ViewPortContainer_mouse_entered", [viewPortContainer])
		viewPortContainer.connect("mouse_exited", self, "_on_ViewPortContainer_mouse_exited")
		hBoxContainer.add_child(viewPortContainer)
		
		var viewPort = Viewport.new()
		viewPort.render_target_update_mode = Viewport.UPDATE_WHEN_VISIBLE
		viewPort.set_script(rayScript)
		viewPorts.append(viewPort)
		var world = World.new()
		var environmentDupe = environment.environment.duplicate()
		environmentDupe.ambient_light_color = Color.white
		world.environment = environmentDupe
		
		
		
		viewPort.world = world
		viewPortContainers.append(viewPortContainer)
		viewPortContainer.add_child(viewPort)
		
		nameLabel = Label.new()
		nameLabel.text = "Name: " + planetsInScene.get_child(i).get_name()
		nameLabel.name = "nameLabel"
		var planet = planetsInScene.get_child(i).duplicate()
		planet.name = planetsInScene.get_child(i).get_name()
		nameDic[planet.name] = planet
		sizeDic[planet.scale[0]] = planet
		planet.get_node("OrbitMeshNode").queue_free()
		sizeLabel = Label.new()
		sizeLabel.text = "Radius: " + String(stepify(planet.scale[0] * 100, 0.01)) + "Km"
		planet.add_child(nameLabel)
		planet.add_child(sizeLabel)
		sizeLabel.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_LEFT)
		viewPort.add_child(planet)
		
		var camera = Camera.new()
		camera.name = "camera"
		camera.set_orthogonal(3.0, 0.05, 50.0)
		camera.translate(Vector3(5.0, 0.0, 0.0))
		camera.look_at(planet.translation, Vector3(0.0, 1.0, 0.0))
		viewPort.add_child(camera)
		cameras.append(camera)
		var omniLight = OmniLight.new()
		planetsInView.append(viewPort.get_child(0))
		viewPort.add_child(omniLight)
		omniLight.translate(Vector3(2.0, 1.0, 0.0))

	updateView()
	pass # Replace with function body.
var mouseInView = false
func _on_ViewPortContainer_mouse_entered(container):
	hoveredViewPortContainer = container
	mouseInView = true
	pass
	
func _on_ViewPortContainer_mouse_exited():
#	hoveredViewPortContainer = null
#	planet = null
	mouseInView = false
	pass

var selectedPlanet
var pressed
var vPort
var mousePos

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			
			if hoveredViewPortContainer:
				vPort = hoveredViewPortContainer.get_child(0)
				mousePos = event.position
#				print(planet.name)

		if event.is_pressed():
			pressed = true
		else:
			pressed = false
	if hoveredViewPortContainer:
		if event is InputEventMouseMotion and pressed:
			if selectedPlanet:
				if mouseInView:
					selectedPlanet.rotatePlanet(event.get_relative())
#				vPort.warp_mouse(mousePos)
		
	pass

func getViewPorts():
	return viewPortContainers
	pass

func _planetUpdateChange(changedPlanet):
	for i in range(planetsInView):
		if changedPlanet.name == planetsInView[i].name:
			planetsInView[i].meshes = changedPlanet.meshes
	pass

func updateView():
	var iter = 0
	for camera in cameras:
		camera.look_at(planetsInView[iter].translation, Vector3(0.0, 1.0, 0.0))
		iter += 1

func _process(delta):

	pass

func _selectPlanetName(planet):
	print(planet)
	selectedPlanet = planet
	namePanel.visible = true
	pass

var planets = []
func sortByName():
	tweenIt(2.0, Color.white, Color.black)
	var planetIndexArr = []
	var planetIndex = 0
	var names = []
	var minId
	for name in nameDic:
		names.append(name)
		planetIndexArr.append(planetIndex)
		planetIndex += 1
		print(names)
	for i in range(names.size()):
		minId = i
		for j in range(i+1, names.size()):
			var maxIt = names[j].length()
			if names[minId][0].to_ascii()[0] > names[j][0].to_ascii()[0]:
				minId = j
			elif names[minId][0].to_ascii()[0] == names[j][0].to_ascii()[0]:
				if names[minId][1].to_ascii()[0] > names[j][1].to_ascii()[0]:
					minId = j
				elif names[minId][1].to_ascii()[0] == names[j][1].to_ascii()[0]:
					if names[minId][2].to_ascii()[0] > names[j][2].to_ascii()[0]:
						minId = j
					elif names[minId][2].to_ascii()[0] == names[j][2].to_ascii()[0]:
						if names[minId][3].to_ascii()[0] > names[j][3].to_ascii()[0]:
							minId = j
		swap(i, minId, names)
		swap(i, minId, planetIndexArr)
	print(names)
	var size = hBoxContainer.get_child_count()
	for i in range(names.size()):
		hBoxContainer.remove_child(viewPortContainers[i])
	for i in range(names.size()):
		hBoxContainer.add_child(viewPortContainers[planetIndexArr[i]])
	pass

func tweenIt(time, color1, color2):
	var tween = self.get_node("ScrollContainer/Tween")
	tween.remove_all()
	tween.interpolate_property(hBoxContainer.get_parent(), "modulate",
			color1, color2, time/4,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(hBoxContainer.get_parent(), "modulate",
			color2, color1, time,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	pass

func swap(a,b, arr):
	var temp = arr[a]
	arr[a] = arr[b]
	arr[b] = temp
	pass

func searchPlanet(text):
	var names = []
	for name in nameDic:
		names.append(name)

	var nonMatchingNames = []
	for name in names:
		if !name.matchn(text + "*"):
			 nonMatchingNames.append(name)

	for viewP in viewPortContainers:
		if nonMatchingNames.has(viewP.get_child(0).get_child(0).name):
			viewP.visible = false
#			viewP.set_h_size_flags(3) #Expand horizontal
#			viewP.set_v_size_flags(3)
		else:
			viewP.visible = true
#			viewP.set_h_size_flags(0) #Expand horizontal
#			viewP.set_v_size_flags(0)
	pass

func sortBySize():
	tweenIt(2.0, Color.white, Color.black)
	var planetIndexArr = []
	var planetIndex = 0
	var sizes = []
	var minId
	for size in sizeDic:
		sizes.append(size)
		planetIndexArr.append(planetIndex)
		planetIndex += 1

	for i in range(sizes.size()):
		minId = i
		for j in range(i+1, sizes.size()):
			if sizes[minId] < sizes[j]:
				minId = j


		swap(i, minId, sizes)
		swap(i, minId, planetIndexArr)
		
	var size = hBoxContainer.get_child_count()
	for i in range(sizes.size()):
		hBoxContainer.remove_child(viewPortContainers[i])
	for i in range(sizes.size()):
		hBoxContainer.add_child(viewPortContainers[planetIndexArr[i]])
	pass

func getPlanetsInScene():
	return 	get_parent().get_child(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_entered(new_text):
	namePanel.visible = false
	var tempNameDic = {}
	for vp in viewPorts:
		var planet = vp.get_child(0)
		
		if planet.name == selectedPlanet.name:
			nameDic.erase(selectedPlanet.name)
			selectedPlanet.name = new_text
			tempNameDic[selectedPlanet.name] = selectedPlanet
			planet.get_node("nameLabel").text = "Name: " + new_text
		tempNameDic[planet.name ] = planet
	nameDic = tempNameDic
	nameEdit.clear()
	selectedPlanet = null
	pass # Replace with function body.
