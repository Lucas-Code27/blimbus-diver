extends Node

signal jumping

@onready var camera: Camera2D = $Camera2D
@onready var diving_board: Sprite2D = $DivingBoard
@onready var blimbusidle: Sprite2D = $Blimbusidle
@onready var arrrow_start: Marker2D = $ArrrowStart
@onready var arrow_end: Marker2D = $ArrowEnd
@onready var splash: Sprite2D = $Splash
@onready var arrow: Sprite2D = $Arrow
@onready var blumbus: AnimatedSprite2D = $Blumbus
@onready var ui: CanvasLayer = $UI
@onready var end_label: Label = $UI/EndLabel

@onready var splash_sound: AudioStreamPlayer = $SplashSound
@onready var die_sound: AudioStreamPlayer = $DieSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound

var safe_range = 318
var safe_start = 393

var can_input: bool = false

func _input(event: InputEvent) -> void:
	if not can_input:
		return
	
	if event.is_action_pressed("jump"):
		jumping.emit()

func _ready() -> void:
	camera.global_position = Vector2(576, -600)
	
	await get_tree().create_timer(0.5).timeout
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(camera, "global_position", Vector2(576, 324), 2).set_trans(Tween.TRANS_BACK)
	await tween.finished
	
	can_input = true
	arrow.start()

func _on_jumping() -> void:
	can_input = false
	jump_sound.play()
	blumbus.show()
	blumbus.global_position = Vector2(arrow.global_position.x, -200)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(blumbus, "global_position", Vector2(arrow.global_position.x, 463.0), 6)
	await tween.finished
	
	if blumbus.global_position.x > safe_start and blumbus.global_position.x < safe_start + safe_range:
		splash.show()
		blumbus.hide()
		splash_sound.play()
	else:
		end_label.text = "You Lose!"
		blumbus.frame += 1
		die_sound.play()
	
	await get_tree().create_timer(1).timeout
	
	ui.show()

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
