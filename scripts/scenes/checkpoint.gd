extends Node3D

var points = 0
var id = get_instance_id()

func _on_area_3d_body_entered(body):
	if body.get_class() == "VehicleBody3D":
		if !body.passed_checkpoints.has(id):
			body.agent.score += points
			body.passed_checkpoints.append(id)
