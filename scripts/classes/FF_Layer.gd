'''
A class with An array of weights and annother of biases
'''
extends Node

class_name FF_Layer

var weights = []
var biases = []

func _init(_weights, _biases):
	weights = _weights
	biases = _biases

func calculate_outputs(x: Array):
	var z = Fns.mat_add(biases, Fns.mat_mul(weights, x))
	var a = Fns.relu(z)

	return a

func cross(par2_layer:FF_Layer):
	var probability
	var child_weights = []
	var child_biases = []
	
	for i in weights.size():
		var rows = []
		for j in weights[i].size():
			var w
			
			probability = randf()
			w =  weights[i][j] if probability > 0.7 else par2_layer.weights[i][j]
			w = mutate_weight(w)
			rows.append(w)
		child_weights.append(rows)
		
		var b
		
		probability = randf()
		b =  biases[i] if probability > 0.7 else par2_layer.biases[i]
		b = [mutate_weight(b[0])]
		child_biases.append(b)
	return FF_Layer.new(child_weights, child_biases)

func mutate_weight(w):
	var rnd = randf_range(-1.0, 1.0)
	var prob = randf()
	
	if prob < 0.5:
		w += w*0.02
	return w

func clone():
	return [weights.duplicate(true), biases.duplicate(true)]
