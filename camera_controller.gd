extends Camera2D
class_name CameraController

func start_camera_shake(time: float):
	print("camera shake")
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(_camera_shake, 10.0, 0.2, time)
	camera_tween.play()
	return camera_tween.finished
func _camera_shake(intensity: float):
	var noise := FastNoiseLite.new()
	var camera_offset = noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	offset.x = camera_offset * randi_range(-1,1)
	offset.y = camera_offset * randi_range(-1,1)
