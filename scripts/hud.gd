extends CanvasLayer

const HEART_SIZE: int = 20
var player
const HEART_FULL = preload("res://Ninja Adventure - Asset Pack/Ui/Receptacle/fullHeart.png")
const HEART_HALF = preload("res://Ninja Adventure - Asset Pack/Ui/Receptacle/halfHeart.png")
const HEART_EMPTY = preload("res://Ninja Adventure - Asset Pack/Ui/Receptacle/emptyHeart.png")
@onready var hearts_container: HBoxContainer = $hearts


func set_player(p) -> void:
	player = p
	if player:
		player.health_change.connect(_update_health)
		_update_health(player.health)
	

func _update_health(new_health: int) -> void:
	var hearts = hearts_container.get_children()
	var max_heart = len(hearts)
	var full = int(new_health / HEART_SIZE)
	var half = 1 if (new_health % HEART_SIZE) > 0 else 0
	var empty = max_heart - (full + half)

	for i in full:
		hearts[i].texture = HEART_FULL
	if half:
		hearts[full].texture = HEART_HALF
	for i in empty:
		hearts[len(hearts)- 1 - i].texture = HEART_EMPTY
