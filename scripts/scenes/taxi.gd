extends VehicleBody3D

var accel = 1000

var angle_between_rays = deg_to_rad(10)
var angle_cone_of_vision = deg_to_rad(180)
var max_view_distance = 20
var rays = []
var ray_distances = []

var steer_target = 0.0
var turn_left = 0.0
var turn_right = 0.0
var accel_up = 0.0
var accel_down = 0.0
var accel_axis = 1.0
var max_rpm = 360
var max_torque = 200

var agent:FF_Agent
var passed_checkpoints = []

var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_y(deg_to_rad(80))
	create_raycasts();

func _physics_process(delta):
	if agent.score < 0:
		dead = true
		queue_free()
	
	if !dead:
		var sensory_info = get_sensory_info()
		var brain_response = agent.brain.feed_forward(sensory_info)
		var turn_difference = 0
	
		set_action_values(brain_response)
		turn_difference = turn_left - turn_right
	
		steer_target = clamp(turn_difference, -1, 1)*0.5
		steering = move_toward(steering, steer_target, delta)
	
	set_engine_froce($wheel_rear_left, accel_axis)
	set_engine_froce($wheel_rear_right, accel_axis)
	#set_engine_froce($wheel_front_left, accel_axis)
	#set_engine_froce($wheel_front_right, accel_axis)
	
func set_action_values(brain_response):
	var brain_out = brain_response.map(func(v): if v[0] < 0: return 0.0 else: return v[0])
	#print(brain_out)
	turn_left = brain_out[0]
	turn_right = brain_out[1]
	accel_up = brain_out[2]
	accel_down = brain_out[3]

	
	if accel_up > accel_down: accel_axis = 1.0 
	else: accel_axis = -1.0
	#accel_axis = accel_up-accel_down
	if accel_up == 0.0 and accel_down == 0.0:
		accel_axis = 0
	
	accel_axis = clamp(accel_up - accel_down, -1, 1)
	
func get_sensory_info():
	var sensory_info = get_ray_distances()
	var speed = linear_velocity.length()
	
	sensory_info.append(speed)
	sensory_info.append(steering)
	
	sensory_info = sensory_info.map(func(i):return [i])
	
	return sensory_info
	#ray_distances = ray_distances.map(func(i):return pow(i,3))
	#ray_distances.append(tanh(speed))
	#ray_distances.append(tanh(steering))
	
func get_ray_distances():
	var dist = 0
	var ray_dist = []
	
	for ray in rays:
		if ray.get_collider():
			dist = position.distance_to(ray.get_collision_point())
			ray_dist.append(max_view_distance - dist)
		else:
			ray_dist.append(0.01)
	return ray_dist
	
func set_engine_froce(wheel:VehicleWheel3D, accel_axis):
	if dead:
		accel_axis = 0
	var rpm = wheel.get_rpm()
	wheel.engine_force = accel_axis * max_torque * (1 - abs(rpm / max_rpm))


func create_raycasts():
	var ray_count = int(angle_cone_of_vision / angle_between_rays)

	for i in range(ray_count):
		var ray = RayCast3D.new()
		var angle  = angle_between_rays * (i - ray_count / 2)
		ray.target_position = Vector3.BACK * max_view_distance
		ray.rotate_y(angle)
		
		rays.append(ray)
		add_child(ray)
