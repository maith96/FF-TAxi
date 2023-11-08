extends Node3D

@export var taxi_scene:PackedScene

@export var population_size: int

@onready var generationTimeLeftLabel = $Control/GenerationTimeLeftLabel
@onready var generationTimer = $GenerationTimer
@onready var spawn_position = $spawnPosition

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
	population.create_next_generation()
	taxis.queue_free()
	assign_and_spawn_taxis()


func _on_generation_timer_timeout():
	if generation_time_left <= 0:
		generation_life_expectancy += 3
		generation_time_left = generation_life_expectancy
		end_of_generation()
	else:
		generation_time_left -= 1

		generationTimeLeftLabel.text =str(generation_time_left)
		generationTimer.start()
