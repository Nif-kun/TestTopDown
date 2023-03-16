extends Actor

var knockback = Vector2.ZERO
onready var sprite = $Bat
onready var stats = $Stats
onready var player_detection = $PlayerDetection

const death_effect = preload("res://worlds/Effects/BatDeath.tscn")

enum{
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	ACCELERATION = 300
	MAX_SPEED = 50
	FRICTION = 200

#Runs the functions.
func _physics_process(delta):
	set_Knockback(delta)
	knockback = move_and_slide(knockback)
	
	set_State()
	match state:
		IDLE:
			Idle_State(delta)
		WANDER:
			pass
		CHASE:
			Chase_State(delta)
	
	move()

func set_State():
	if player_detection.can_see_player():
		state = CHASE
	else:
		state = IDLE

func move():
	_velocity = move_and_slide(_velocity)

func Idle_State(delta):
	_velocity = _velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func Chase_State(delta):
	var player = player_detection.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		_velocity = _velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = _velocity.x < 0

func set_Knockback(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) #Applied first value of knockback

#"You call down and signal up"
#This means you call on your child node, in this case, the stats node.
#You then create a signal in that node to use it here. In this case, the _on_Stats_no_health()
#This is to avoid going down and changing values of child node and more cleaner code.
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage #This is the call
	knockback = area.knockback_direction * ACCELERATION #The final applied knockback when the sword hits.

#This is a signal made in stats.
func _on_Stats_no_health():
	var death_Effect = death_effect.instance()
	get_parent().add_child(death_Effect)
	death_Effect.global_position = global_position
	queue_free()
