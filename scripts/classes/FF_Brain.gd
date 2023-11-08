'''
The brain is a feed forward Neural Network, made up of stacks of layers.

'''
extends Node

class_name FF_Brain

var layers = []


func _init(_layers):
	layers = _layers

func feed_forward(x):
	for l in layers:
		x = l.calculate_outputs(x)
		
	return x
	
static func new_layers(in_nodes,out_nodes, hidden_size:=[0,0]):
	var _layers = []
	var weights
	var biases
	var layer
	
	if hidden_size[0] == 0:
		weights = Fns.rand_mat(out_nodes, in_nodes)
		biases = Fns.rand_mat(out_nodes, 1)
		return [FF_Layer.new(weights, biases)]
	
	var rows = hidden_size[1]
	var cols = in_nodes
	
	'''Hidden layer'''
	for i in range(hidden_size[0]):
		weights = Fns.rand_mat(rows, cols)
		biases = Fns.rand_mat(rows, 1)
		layer = FF_Layer.new(weights, biases)
		_layers.append(layer)
		cols = rows
		
	'''output layer'''
	rows = out_nodes
	weights = Fns.rand_mat(rows, cols)
	biases = Fns.rand_mat(rows, 1)
	layer = FF_Layer.new(weights, biases)
	_layers.append(layer)
	
	return _layers
