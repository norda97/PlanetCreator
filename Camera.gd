#extends Camera
#
#export(Vector3) var cameraOffset
#var cameraNewRotation
#var direction
#var cameraHolderX
#var cameraHolderY
#var cameraHolderMaster
#var secondCamera
#var zoomSpeed = 0.1
#var currentCamera
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#
#	cameraOffset = Vector3(5, 0, 0)
#
##	self.translate(cameraOffset)
#	cameraHolderX = self.get_parent()
#	cameraHolderY = self.get_parent().get_parent()
#	cameraHolderMaster = self.get_parent().get_parent().get_parent()
#	secondCamera = cameraHolderMaster.get_node("TopViewCamera")
##	secondCamera.set_as_toplevel(true)
#	currentCamera = getCurrentCamera()
#	updateLookAt()
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##
##
##	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
##		if self.is_current():
##
##			if cameraHolderX.rotation.x < deg2rad(80):
##				cameraHolderX.rotate_x(cameraNewRotation[1] * 0.01)
##			else:
##				cameraHolderX.rotation.x = deg2rad(79)
##
##			if cameraHolderX.rotation.x > -deg2rad(80):
##				cameraHolderX.rotate_x(cameraNewRotation[1] * 0.01)
##			else:
##				cameraHolderX.rotation.x = -deg2rad(79)
##
##			cameraHolderY.rotate_y(cameraNewRotation[0] * 0.01)
##			cameraNewRotation = Vector2(0.0, 0.0)
##		elif secondCamera.is_current():
##			cameraHolderMaster.translate(Vector3(cameraNewRotation[0] * 0.1, 0.0, cameraNewRotation[1] * 0.1))
##			cameraNewRotation = Vector2(0.0, 0.0)
##
##	updateLookAt()
#
#func updateLookAt():
#	direction = -currentCamera.transform.origin.normalized()
#	self.look_at(cameraHolderMaster.transform.origin, Vector3(0.0, 1.0, 0.0))
#	pass
#
#func _input(event):
##	currentCamera = getCurrentCamera()
##	if event is InputEventMouseMotion:
##		cameraNewRotation = event.get_relative()
##	if event is InputEventMouseButton:
##		if event.button_index == BUTTON_WHEEL_UP:
##			if self.is_current():
##				self.translation = self.translation + direction * zoomSpeed
##			elif secondCamera.is_current():
##				secondCamera.translation = secondCamera.translation + direction * 0.8
##		if event.button_index == BUTTON_WHEEL_DOWN:
##			if self.is_current():
##				self.translation = self.translation - direction * zoomSpeed
##			elif secondCamera.is_current():
##				secondCamera.translation = secondCamera.translation - direction * 0.8
##
#	pass
#
#func getCurrentCamera():
#	if self.is_current():
#		return self
#	elif secondCamera.is_current():
#		return secondCamera
#	pass
#
