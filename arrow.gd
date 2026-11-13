extends Sprite2D

@export var start_point: Marker2D
@export var end_point: Marker2D

var move_time: float = randf_range(0.08, .4)

var tween: Tween

func start() -> void:
	global_position = start_point.global_position
	
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property(self, "global_position", end_point.global_position, move_time)
	tween.tween_property(self, "global_position", start_point.global_position, move_time)


func _on_main_jumping() -> void:
	tween.kill()
