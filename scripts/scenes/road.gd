extends Node3D

@export var checkpoint_scene:PackedScene
@export var negativeCheckpoint_scene: PackedScene
@export var distance_between_ckpts = 10.0



# Called when the node enters the scene tree for the first time.
func _ready():
	create_checkpoints()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_checkpoints():
	var path = $Path3D
	var path_follow = $Path3D/PathFollow3D
	
	var path_dist = path.get_curve().get_baked_length()
	var num_ckpts = floor(path_dist / distance_between_ckpts)
	var score = distance_between_ckpts
	var offset = 10
	
	print(path_dist)
	print(num_ckpts)
	
	for i in range(num_ckpts): 
		var ckpt = checkpoint_scene.instantiate()
		var negative_ckpt = negativeCheckpoint_scene.instantiate()
		var dist_to_ckpt = offset + distance_between_ckpts * i
		var point = path.get_curve().sample_baked(dist_to_ckpt, true)
		var up_vector = path.get_curve().sample_baked_up_vector(dist_to_ckpt, true)
		var forward_direction = point.direction_to(path.get_curve().sample_baked(dist_to_ckpt+0.001, true))
		
		var basis = Basis()
		basis.y = up_vector
		basis.x = forward_direction.cross(up_vector).normalized()
		basis.z = -forward_direction

		var trans = Transform3D(basis, point)
		ckpt.set_transform(trans)
		negative_ckpt.set_transform(trans)
		
		ckpt.points = score
		negative_ckpt.points = score 
		if i > 15:
			negative_ckpt.points =  i* score
		add_child(ckpt)
		if i > 5:
			#add_child(negative_ckpt)
			pass
		score = distance_between_ckpts +i
		offset = distance_between_ckpts / 2.0
		
