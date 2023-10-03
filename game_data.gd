extends Node
## Синглтон для хранения, записи и считыания из файла данных об игре

const data_path := "user://karoshi_save.dat"

var levels_completed: int	# Кол-во пройденых уровней
var music_enabled: bool		# Включена ли музыка
var sound_enabled: bool		# Включён ли звук
var vibro_enabled: bool 	# Включена ли вибрация


func _ready():
	if is_game_data_exists():
		load_data()
	else:
		create_data()


# Проверка, существует ли файл с данными об игре
func is_game_data_exists() -> bool:
	var f = File.new()
	var result = f.file_exists(data_path)
	f.close()
	return result


# Вызывается при первом запуске, сохраняет базовые данные
func create_data() -> void:
	levels_completed = 0
	music_enabled = true
	sound_enabled = true
	vibro_enabled = true
	save_data()


# Загрузка данных об игре из внешнего файла
func load_data():
	var f := File.new()
	# warning-ignore:return_value_discarded
	f.open(data_path, File.READ)
	levels_completed = f.get_8()
	music_enabled = bool(f.get_8())
	sound_enabled = bool(f.get_8())
	vibro_enabled = bool(f.get_8())
	f.close()


# Запись данных об игре в файл
func save_data():
	var f := File.new()
	# warning-ignore:return_value_discarded
	f.open(data_path, File.WRITE)
	f.store_8(levels_completed) # Кол-во открытых уровней
	f.store_8(int(music_enabled)) # Включена ли музыка
	f.store_8(int(sound_enabled)) # Включен ли звук
	f.store_8(int(vibro_enabled)) # Включен ли звук
	f.close()
