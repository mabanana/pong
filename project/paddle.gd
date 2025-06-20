extends CharacterBody2D
class_name Paddle

var speed = 30
var max_speed = 500
var direction: int
var screen_size: Vector2
var start_x: float

var controls := []

func _ready():
	start_x = position.x

func _physics_process(delta):
	velocity.y += speed * direction
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	position.x = start_x
		
	move_and_slide()
	flip_coordinates()

func _input(event):
	direction = Input.get_axis(controls[0], controls[1])

func flip_coordinates():
	if position.x > screen_size.x:
		position.x = 0
	elif position.x < 0:
		position.x = screen_size.x
	
	if position.y > screen_size.y:
		position.y = 0
	elif position.y < 0:
		position.y = screen_size.y
