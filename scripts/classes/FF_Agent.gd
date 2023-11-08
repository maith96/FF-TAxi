extends Node


class_name FF_Agent

var brain: FF_Brain
var score = 0

func _init(_brain):
	brain = _brain

func make_child(par2: FF_Agent):
	var child: FF_Agent
	var child_layers = []
	var layer: FF_Layer
	
	for i in brain.layers.size():
		layer = brain.layers[i].cross(par2.brain.layers[i])
		child_layers.append(layer)
	
	child = FF_Agent.new(FF_Brain.new(child_layers))
	return child
