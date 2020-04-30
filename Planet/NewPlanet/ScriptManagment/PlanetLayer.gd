class_name PlanetLayer extends Reference

var planetClass = load("res://Planet/NewPlanet/NewPlanet.gd")

class LayerEvent extends Reference:
	var update = false
	var layer
	var type
	
	func setUpdated(updated):
		update = true
		layer.setUpdated(updated)

class FillEvent extends LayerEvent:
	var color
	
	func _init(type, layer, color):
		self.type = type
		self.layer = layer
		self.color = color

class NoiseEvent extends LayerEvent:
	var period
	var octave
	var color
	
	func _init(type, layer,  period, octave, color):
		self.type = type
		self.layer = layer
		self.period = period
		self.octave = octave
		self.color = color

var events = []
var name
var layerIndex
var update = false

func _init(name, index):
	self.name = name
	self.layerIndex = index
	pass

func getUpdated():
	return update

func setUpdated(updated):
	update = true

func _process(dt):
	update = false

func removeEvent(event):
	var index = events.find(event)
	if index != -1:
		events.remove(index)

func getEvents():
	return events	

func addFill(color):
	var e = FillEvent.new(planetClass.EventType.FILL, self, color)
	events.append(e)
		
	return events.back()
	pass
	
func addNoise(period, octave, color):
	var e = NoiseEvent.new(planetClass.EventType.NOISE, self, period, octave, color)
	events.append(e)
	
	return events.back()
	pass

