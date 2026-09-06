extends Node2D

@onready var spinners: Node2D = $Sprite2D/Spinners
@onready var stats: Node2D = $Sprite2D/Static

@onready var label: Label = $"../Control/Label"
var money = 15

var offset_pos: float = 899
var regular_pos: float = 0

var guy_pos: float = -899
var guy_here: bool = false
@onready var guy: Sprite2D = $Guy

func save():
	var savedata = {"money":money}
	var file = FileAccess.open("user://Save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(savedata))
		file.close()

func loadgame():
	if FileAccess.file_exists("user://Save.json"):
		var file = FileAccess.open("user://Save.json", FileAccess.READ)
		var string = file.get_as_text()
		file.close()
		var data = JSON.parse_string(string)
		if data is Dictionary:
			money = int(data.get("money", 0))
func spin(money_lost):
	$Timer.start()
	money -= money_lost
	for child in spinners.get_children():
		child.visible = true
	for child in stats.get_children():
		child.visible = false

func stop():
	var results=[]
	
	for i in range(1,4):
		var randy = randi_range(1,6)
		var spinner = spinners.get_node("Spinner" + str(i))
		var stat = stats.get_node("Stat" + str(i))
		
		spinner.visible = false
		stat.texture = load("res://Dice" + str(randy) + ".tres")
		stat.scale = Vector2(8.5, 8.5)
		stat.visible = true
		results.append(randy)
		if i < 3:
			await get_tree().create_timer(0.5).timeout
	check(results)

func check(results):
	match results:
		[var a, var b, var c] when a == b and b == c:
			print("BIG WIN")
			money+=50*a
		[var a, var b, var c] when a == b or a == c:
			print("WINNER")
			money+=10*a
		[var a, var b, var c] when b == c:
			print("WINNER")
			money+=10*b

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		position.x = lerp(position.x, offset_pos, 0.5)
	else:
		position.x = lerp(position.x, regular_pos, 0.5)
	
	if Input.is_action_just_pressed("kick"):
		if guy_here:
			return
		spin(0)
	
	label.text = str(money)
	if Input.is_action_just_pressed("ui_accept") and $Timer.is_stopped():
		spin(5)

func _ready() -> void:
	loadgame()


func _on_timer_timeout() -> void:
	stop()


func _on_button_pressed() -> void:
	save()
	get_tree().quit()


func _on_button_2_pressed() -> void:
	var savedata = {"money":money}
	var file = FileAccess.open("user://Save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(0))
		file.close()
		get_tree().quit()


func _on_guy_timer_timeout() -> void:
	match randi_range(0,1):
		0:
			guy_here = true
			guy.visible = true
			print("guy here")
		1:
			guy_here = false
			guy.visible = false
