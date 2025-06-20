extends RigidBody2D
class_name Ball

var speed = 200
var dir := Vector2.ONE
var screen_size: Vector2
var paddle_hit

@export var particle: GPUParticles2D
@export var ready_particle: GPUParticles2D

func _ready():
	$Area2D.body_entered.connect(flip_x)
	ready_particle.emitting = true

func _physics_process(delta):
	if position.y + 50 > screen_size.y:
		dir.y = -1
		apply_central_impulse(Vector2.UP * speed)
	elif position.y - 50 < 0:
		dir.y = 1
		apply_central_impulse(Vector2.DOWN * speed)
		
	apply_force(dir * speed)

func flip_x(body):
	if body is Paddle:
		dir.x *= -1
		apply_central_impulse(-linear_velocity)
		apply_central_impulse(Vector2(dir.x, 0) * speed * 2)
		apply_central_impulse(Vector2(0, body.velocity.y) / 2)
		particle.restart()
		particle.emitting = true
		print("boop")
		paddle_hit.emit(1)
