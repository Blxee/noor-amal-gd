class_name Prompt
extends Control

const SCENE_PATH = preload('res://scenes/prompt.tscn')

signal ok_pressed()
signal cancel_pressed()

@export var message: String:
	set(value):
		message = value
		%Message.text = message

@export var is_alert: bool = false:
	set(value):
		is_alert = value
		%Cancel.visible = not is_alert


static func create_prompt(
	message: String,
	is_alert: bool = true,
	on_ok: Callable = func():,
	on_cancel: Callable = func():,
) -> Prompt:
	var scene = SCENE_PATH.instantiate()
	scene.message = message
	scene.is_alert = is_alert
	scene.ok_pressed.connect(on_ok)
	scene.cancel_pressed.connect(on_cancel)
	return scene


func _on_ok_pressed() -> void:
	ok_pressed.emit()
	queue_free()


func _on_cancel_pressed() -> void:
	cancel_pressed.emit()
	queue_free()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_on_cancel_pressed()
