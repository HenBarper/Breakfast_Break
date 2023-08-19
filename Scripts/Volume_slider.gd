extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name) # get index of Audio bus(Music or SFX)
	value_changed.connect(_on_value_changed) # connect the signal of the slider
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index) # get the current volume to set the slider value
	)

func _on_value_changed(value: float) -> void: # changed volume to slider value translated linearly to db
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
