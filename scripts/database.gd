class_name DataBase
extends Resource

signal updated()

const save_path: String = 'user://database.res'

@export var table: Array[Entry] = []


static func save_data(data_base: DataBase) -> void:
	ResourceSaver.save(data_base, save_path)
	data_base.updated.emit()


static func load_data() -> DataBase:
	if ResourceLoader.exists(save_path):
		return ResourceLoader.load(save_path)
	else:
		return new()


func add_entry(entry: Entry) -> void:
	if entry not in table:
		table.append(entry)
		save_data(self)


func remove_entry(entry: Entry) -> void:
	table.erase(entry)
	save_data(self)
