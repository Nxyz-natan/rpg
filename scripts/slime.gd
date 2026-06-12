extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var takedamage_sound: AudioStreamPlayer2D = $takedamage
@onready var healthbar: Node2D = $healthbar
@onready var attacktimer: Timer = $attacktimer


const SPEED: int = 100
var target = null
var target_in_range: bool = false
var health: int = 100
var strength: int = 10
const kncockback_force: int = 100
var is_alive: bool = true

func _physics_process(delta: float) -> void:
	if is_alive and target:
		_attack(	delta)




func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += direction * SPEED * delta 
	animated_sprite_2d.play("attack")
	

func take_damage(damage: int , attacker_position: Vector2) -> void:
	health -= damage
	healthbar.update_health(health)
	if health <= 0:
		_die()
	else:
		takedamage_sound.play()
		var knockback_dirction = (position - attacker_position).normalized()
		var target_position = position + knockback_dirction * kncockback_force
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position" , target_position, 0.5)


func _die() -> void:
	is_alive = false
	animated_sprite_2d.play("death")
	takedamage_sound.pitch_scale = 0.1
	takedamage_sound.play()
	$CollisionShape2D.set_deferred("disabled" , true)
	$sight/CollisionShape2D.set_deferred("disabled" , true)
	


func _on_sight_body_entered(body: Node2D) -> void:
	if body.name ==  "player":
		target = body





func _on_sight_body_exited(body: Node2D) -> void:
	if body.name ==  "player" and is_alive:
		target = null
		animated_sprite_2d.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "player":
		target_in_range = true
		body.take_damage(strength)
		attacktimer.start()
		


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "player":
		target_in_range = false
		attacktimer.stop()

func _on_attacktimer_timeout() -> void:
	if target and target_in_range:
		target.take_damage(strength)
