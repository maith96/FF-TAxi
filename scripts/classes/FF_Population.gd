extends Node

class_name FF_Population

var population_size: int
var agents: Array
var gen_agents_save_path = "user://gen_agents.res"

func _init(_population_size):
	population_size = _population_size
	create_Adams()

func create_Adams():
	for i in range(population_size):
		var layers = FF_Brain.new_layers(20, 4, [1,10])
		var brain = FF_Brain.new(layers)
		var agent = FF_Agent.new(brain)
		agents.append(agent)

'''Create offsprings'''
func create_next_generation():
	agents.sort_custom(sort_agents)
	agents = crossover()

func crossover():
	var par1: FF_Agent
	var par2: FF_Agent
	var next_generation_agents = []
	var fitness_probabilities = calculate_fitness_probabilities()
	var five_percent = int(0.05 * agents.size())
	var children_size = population_size - five_percent
	
	next_generation_agents = agents.slice(0, five_percent)
	
	for i in range(children_size):
		par1 = Fns.choice(agents, fitness_probabilities)
		par2 = Fns.choice(agents, fitness_probabilities)
		while(par2 == par1):
			par2 = Fns.choice(agents, fitness_probabilities)
		next_generation_agents.append(par1.make_child(par2))
	
	return next_generation_agents

func calculate_fitness_probabilities():
	var fitness_scores = [] 
	var fitness_probabilities = []
	
	fitness_scores = get_agent_scores()
	fitness_probabilities = Fns.probabilities(fitness_scores)
	
	return fitness_probabilities

func sort_agents(a, b):
	return a.score > b.score

func get_agent_scores():
	var scores = []
	for a in agents:
		if a.score < 0: a.score = 0
		scores.append(a.score)
	return scores

func load_gen_agents():
	if ResourceLoader.exists(gen_agents_save_path):
		var gen_agents = ResourceLoader.load(gen_agents_save_path)
		return gen_agents
	return null

func create_gen_agents_from_load(brains):
	agents = []
	for b in brains:
		var layers = create_layers(b)
		var brain = create_brain(layers)
		var agent = create_agent(brain)
		agents.append(agent)

func create_layers(layers_arr):
	var layers = []
	for l in layers_arr:
		layers.append(FF_Layer.new(l[0], l[1]))
	return layers

func create_brain(layers):
	return FF_Brain.new(layers)

func create_agent(brain):
	return FF_Agent.new(brain)
