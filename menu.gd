extends Control

@export var training_scene:PackedScene
@export var trained_scene:PackedScene




func _on_load_button_pressed():
	get_tree().change_scene_to_packed(trained_scene)


func _on_train_button_pressed():
	get_tree().change_scene_to_packed(training_scene)

