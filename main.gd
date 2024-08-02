extends Node2D

signal mouse_clicked

@onready var blue = $Blue
@onready var red = $Red
@onready var green = $Green

@onready var hud = $HUD

var left_click_action = "left_click"
var restart_action = "restart"

var current_round:int = 0
var max_rounds:int = 5

var min_time_wait_sec:float = 2.0
var first_round_extra_wait_sec:float = 1.0
var stopwatch_start:float
var stopwatch_end:float
var total_time:float = 0

func _ready() -> void:
	red.hide()
	green.hide()
	blue.show()
	#Engine.max_fps = 120


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(left_click_action):
		mouse_clicked.emit()
		#emit_signal("mouse_clicked")
	if Input.is_action_just_pressed(restart_action):
		get_tree().reload_current_scene()


# signal from HUD's startbutton
func _on_hud_start_test() -> void:
	current_round = 0
	while current_round < max_rounds:
		await new_round()
		current_round += 1
		
	# average
	red.hide()
	green.hide()
	blue.show()
	hud.set_text("Average: " + str(total_time / max_rounds) + " milliseconds")
	await mouse_clicked
	get_tree().reload_current_scene()


func new_round():
	blue.hide()
	green.hide()
	red.show()
	hud.set_text("Wait for green")
	
	# extra wait for first round
	if current_round == 0:
		await get_tree().create_timer(first_round_extra_wait_sec)
	
	await get_tree().create_timer(min_time_wait_sec + randf_range(0.0, 5.0)).timeout
	green.show()
	stopwatch_start = Time.get_ticks_msec()
	hud.set_text("Click!")
	await mouse_clicked
	stopwatch_end = Time.get_ticks_msec()
	green.hide()
	red.hide()
	blue.show()
	hud.set_text(str(stopwatch_end - stopwatch_start) + " milliseconds")
	
	total_time += stopwatch_end - stopwatch_start
	hud.annotation.show()
	await mouse_clicked
	hud.annotation.hide()
