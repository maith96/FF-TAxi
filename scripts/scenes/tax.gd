extends VehicleBody3D

var target_area: Area3D
var start_area: Area3D



var agent:NN_agent



var sensory_info = []
# Called when the node enters the scene tree for the first time.
func _ready():
	create_raycasts()
	#print(agent.fitness)


# Called every frame. 'delta' is the elapsed time since the previous frame.

	




func set_action_values(brain_out):
	brain_out = brain_out.map(func(v): if v < 0: return 0.0 else: return v)
	#print(brain_out)
	turn_left = brain_out[0]
	turn_right = brain_out[1]
	accel_down = brain_out[3]
	
	if accel_up > accel_down: accel_axis = 1.0 
	else: accel_axis = -1.0
	#accel_axis = accel_up-accel_down
	if accel_up == 0.0 and accel_down == 0.0:
		accel_axis = 0

# sensors include:
# * ray distances - 8
# * speed
# * steer angle
func get_sensory_info():
	sensory_info.clear()
	sensory_info = get_ray_distances()
	sensory_info = sensory_info.map(func(i):return pow(i,3))
	var speed = linear_velocity.length()
	sensory_info.append(tanh(speed))
	sensory_info.append(tanh(steering))

	#print(sensory_info)

func get_ray_distances():
	var ray_dist =[]
	for ray in rays:
		if ray.get_collider():
			var dist = position.distance_to(ray.get_collision_point())
			ray_dist.append(dist/max_view_distance)
		else:
			ray_dist.append(1.0)

	return ray_dist

func update_fitness():
	var fitness = start_area.position.distance_to(target_area.position) - position.distance_to(target_area.position) 
	#agent.fitness = fitness


