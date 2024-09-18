extends Control

const USER_LIST_ITEM = preload("res://scenes/user_list_item.tscn")

var database: DataBase = DataBase.load_data()

@onready var user_form: Control = %UserForm

func _ready() -> void:
	user_form.database = database
	
	for entry in database.table:
		var list_item = USER_LIST_ITEM.instantiate()
		list_item.entry = entry
		%UserList.add_child(list_item)


func _on_add_user_pressed() -> void:
	user_form.entry = Entry.new()
	user_form.show()


func edit_user(entry: Entry) -> void:
	user_form.entry = entry
	user_form.show()
