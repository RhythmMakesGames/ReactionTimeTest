extends CanvasLayer

signal start_test

@onready var start_button = $StartButton
@onready var text_box = $TextBox
@onready var annotation = $Annotation

func _ready() -> void:
	annotation.hide()


func _process(delta: float) -> void:
	pass


func _on_start_button_button_down() -> void:
	start_button.hide()
	start_test.emit()


func set_text(text: String):
	text_box.text = text
