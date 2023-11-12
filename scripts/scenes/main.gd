extends Node3D

@export var taxi_scene:PackedScene

@export var population_size: int

@onready var generationTimeLeftLabel = $Control/GenerationTimeLeftLabel
@onready var generationTimer = $GenerationTimer
@onready var spawn_position = $spawnPosition

var save_path = "user://best.res"
var gen_agents_save_path = "user://gen_agents.res"

var best = BestAgent.new()
var generationAgents = GenAgents.new()


var taxis: Node3D

var population: FF_Population
var generation_life_expectancy = 5
var generation_time_left = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	population = FF_Population.new(population_size)
	generation_time_left = generation_life_expectancy
	assign_and_spawn_taxis()
	generationTimer.start()

func assign_and_spawn_taxis():
	var best_agent = (population.agents[0])
	print("bestScore: ",population.agents[0].score)
	save(best_agent)
	taxis = Node3D.new()
	generationTimer.start()
	for i in range(population_size):
		var taxi_model = taxi_scene.instantiate()
		population.agents[i].score = 0

		taxi_model.agent = population.agents[i]
		taxi_model.position = spawn_position.position
		taxis.add_child(taxi_model)
	add_child(taxis)
		
func end_of_generation():
	save_gen_agents()
	population.create_next_generation()
	taxis.queue_free()
	assign_and_spawn_taxis()

func save(_best):
	best.brain = _best.brain.clone()
	var res = ResourceSaver.save(best, save_path)
	assert(res == OK)

func save_gen_agents():
	if len(generationAgents.brains) < 0:
		generationAgents.brains = []
	
	for agent in population.agents:
		generationAgents.brains.append(agent.brain.clone())
		var res = ResourceSaver.save(generationAgents, gen_agents_save_path)
		assert(res == OK)
		

func _on_generation_timer_timeout():
	if generation_time_left <= 0:
		generation_life_expectancy += 1
		generation_time_left = generation_life_expectancy
		end_of_generation()
	else:
		generation_time_left -= 1

		generationTimeLeftLabel.text =str(generation_time_left)
		generationTimer.start()
