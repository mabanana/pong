extends Control
class_name HudController

@export var p1_label: Label
@export var p2_label: Label
@export var win_message: Label
@export var canvas_layer: CanvasLayer

var labels: Array[Label]
var scene:Node2D

func _ready():
	labels = [p1_label, p2_label]
	
func _update():
	for i in range(len(labels)):
		if labels[i].text != str(scene.score[i]):
			animate_score(i)
		labels[i].text = str(scene.score[i])

func start_camera_shake(time: float, start_size = 40):
	var tween = get_tree().create_tween()
	tween.tween_method(_camera_shake.bind(start_size), 3.0, 0.2, time)
	tween.play()
	return tween.finished
func _camera_shake(intensity: float, start_size):
	var noise := FastNoiseLite.new()
	var camera_offset = noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	p1_label.label_settings.font_size = start_size + camera_offset * randi_range(-10,10)
	p2_label.label_settings.font_size = start_size + camera_offset * randi_range(-10,10)

func show_message(id):
	win_message.show()
	for i in range(len(labels)):
		labels[i].label_settings.font_size = 200
	start_camera_shake(0.2, 200)
	
	var offset = scene.screen_size.x / 2 - 150
	var y_pos = -scene.screen_size.y / 2 + 200
	
	if id == 0:
		offset *= -1
	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(win_message, "position", Vector2(offset, y_pos), 1)
	tween.set_parallel()
	tween.tween_property(win_message, "modulate", Color(1,1,1,0), 1)
	tween.play()
	tween.finished.connect(func():
		win_message.position = Vector2(-86, -34.5)
		win_message.scale = Vector2.ONE
		win_message.modulate = Color.WHITE
		win_message.hide()
		for i in range(len(labels)):
			labels[i].label_settings.font_size = 40
		)
	return tween.finished
	
func animate_score(i):
	var score_tween = get_tree().create_tween()
	score_tween.set_trans(Tween.TRANS_BACK)
	score_tween.tween_property(labels[i], "modulate", Color(1,0.1,0.12,1), 0.2)
	score_tween.tween_property(labels[i], "modulate", Color(1,1,1,1), 0.1)
	score_tween.play()
