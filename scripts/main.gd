extends Node

@onready var player = $LevelRoot/player
@onready var hud = $HUD

func _ready() -> void:
	call_deferred("setup_ui")

func setup_ui() -> void:
	hud.set_player(player)
