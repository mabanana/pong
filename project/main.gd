extends Node2D

@export var endzone_1: Endzone
@export var endzone_2: Endzone
@export var hud: HudController
@export var camera: CameraController

@export var player_x_offset: int
var screen_size: Vector2

var p1: Paddle
var p2: Paddle
var ball: Ball

var score = [0,0]

signal paddle_hit

func _ready():
	screen_size = get_viewport_rect().size
	$CanvasLayer/HBoxContainer/HSlider.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(0, clampf(value, -32, 0))
	)
	await get_tree().create_timer(3).timeout
	$CanvasLayer/Label.hide()
	_spawn_players()
	_spawn_ball()
	endzone_1.id = 1
	endzone_2.id = 2
	hud.scene = self
	
	paddle_hit.connect(camera.start_camera_shake)
	paddle_hit.connect(hud.start_camera_shake)	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _spawn_players():
	p1 = load("res://paddle.tscn").instantiate()
	p2 = load("res://paddle.tscn").instantiate()
	
	p1.position = Vector2(player_x_offset, screen_size.y/2)
	p2.position = Vector2(screen_size.x - player_x_offset, screen_size.y/2)
	
	p1.screen_size = screen_size
	p2.screen_size = screen_size
	
	p1.controls = ["up_1", "down_1"]
	p2.controls = ["up_2", "down_2"]
	
	add_child(p1)
	add_child(p2)

func _spawn_ball():
	ball = load("res://ball.tscn").instantiate()
	ball.position = screen_size/2
	ball.screen_size = screen_size
	ball.dir = Vector2(1, randf() / 2).normalized()
	ball.paddle_hit = paddle_hit
	add_child(ball)
	
	endzone_1.body_entered.connect(_on_body_entered.bind(1))
	endzone_2.body_entered.connect(_on_body_entered.bind(2))

func _on_body_entered(body, id):
	if body is Ball:
		print("endzone %s reached." % [id])
		score[2-id] += 1
		ball.queue_free()
		hud.show_message(2-id)
		$AudioStreamPlayer5.play()
		await get_tree().create_timer(1).timeout
		$AudioStreamPlayer4.play()
		hud._update()
		get_tree().create_timer(3).timeout.connect(_spawn_ball)
