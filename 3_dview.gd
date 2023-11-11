extends Node3D

var save_path = "user://best.res"
@onready var taxi = $BlindGirl

func _ready():
	var saved_best_layers = load_saved().brain
	print(saved_best_layers)
	if saved_best_layers:
		var layers = create_layers(saved_best_layers)
		var brain = create_brain(layers)
		var agent = create_agent(brain)
		taxi.agent = agent
	

func load_saved():
	if ResourceLoader.exists(save_path):
		var best_agent = ResourceLoader.load(save_path)
		return best_agent
	return null

func create_layers(layers_arr):
	var layers = []
	for l in layers_arr:
		layers.append(FF_Layer.new(l[0], l[1]))
	return layers

func create_brain(layers):
	return FF_Brain.new(layers)

func create_agent(brain):
	return FF_Agent.new(brain)
