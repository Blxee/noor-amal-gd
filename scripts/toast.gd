class_name Toast
extends Control

const TOAST = preload("res://scenes/toast.tscn")

var colors := {
	'info': Color('#154dff'),
	'success': Color('#00a51c'),
	'danger': Color('#be0023'),
}

var message: String:
	set(value):
		message = value
		%Message.text = message

@onready var type: String = 'info':
	set(value):
		type = value
		$PanelContainer.get_theme_stylebox('panel').bg_color = colors[type]


static func create_toast(msg: String, type: String = 'info') -> Toast:
	var toast := TOAST.instantiate()
	toast.message = msg
	toast.type = type
	return toast


func _ready() -> void:
	$PanelContainer.get_theme_stylebox('panel').bg_color = colors['info']
	var tween := create_tween()
	modulate = Color.TRANSPARENT
	tween.tween_property(self, 'modulate', Color.WHITE, 0.5)
	tween.tween_callback($Timer.start)


func _on_timer_timeout() -> void:
	var tween := create_tween()
	tween.tween_property(self, 'modulate', Color.TRANSPARENT, 0.5)
	tween.tween_callback(queue_free)
