extends KinematicBody2D


const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const HitSound = preload("res://Music and Sounds/HitSound.tscn")
const DieSound = preload("res://Music and Sounds/DieSound.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE,
}

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtBox = $Hurtbox
onready var softCollition = $SoftCollision

var hitSound = null
var dieSound = null

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = CHASE

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null && is_instance_valid(player):
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
		
	if softCollition.is_colliding():
		velocity += softCollition.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtBox.create_hit_effect()
	make_hit_sound()


func _on_Stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	make_die_sound()

func make_die_sound() -> void:
	if dieSound == null:
		dieSound = DieSound.instance()
		get_parent().add_child(dieSound)
	dieSound.play()

func make_hit_sound() -> void:
	if hitSound == null:
		hitSound = HitSound.instance()
		get_parent().add_child(hitSound)
	hitSound.play()
