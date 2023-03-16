extends Actor

enum{
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var _roll_velocity = Vector2.DOWN
const ROLL_MAX_SPEED = 125
onready var sword_hitbox = $HitboxPivot/SwordHitbox #Calls the node/script that will have values changed.

func _ready():
	_animation_tree = $AnimationTree #Dollar sign symbolizes node
	
	#This is basically the Parameters -> Playback in AnimationTree node.
	#It takes in the Playback, which in this case: AnimationNodeStateMachine, which you chose at Tree Root
	_animation_state = _animation_tree.get("parameters/playback") 
	_animation_tree.active = true

func _physics_process(delta):
	set_Animation_Player_State()
	match state:
		MOVE:
			set_Animation_Move(delta)
		ROLL:
			set_Animation_Roll(delta)
		ATTACK:
			set_Animation_Attack()
#	print(_velocity)

func move():
	_velocity = move_and_slide(_velocity)

func get_Direction() -> Vector2:
	var direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	return direction

func set_Velocity(delta: float, direction: Vector2):
#	.move_toward(from, to): in this program, "to" is used as the increasing speed (ACCELERATION), 
#	while "from" is the end point or cap.
	if direction != Vector2.ZERO:
#		(direction * MAX_SPEED): is the speed cap of the player.
#		(ACCELERATION * delta): is the added speed per second.
		_velocity = _velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		
#		Vector2.ZERO is the cap when you let go of the movement key.
#		(FRICTION * delta): is the added speed per second. In this case, the increase used to reach the cap faster.
#		When there is/are no pressed movement key(s) (direction), the line below will force the player to reach 
#		the destination (cap) at a faster rate. The lower the FRICTION is, the slower it takes, causing a sliding 
#		or slippery  effect.
		_velocity = _velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func set_Animation_Move(delta):
	var direction = get_Direction()
	set_Velocity(delta, direction)
	#Checks direction
	if direction != Vector2.ZERO:
		
		#This is to get the last position/direction for the knockback to apply.
		sword_hitbox.knockback_direction = direction
		
		#This is to get the last position/direction for the roll to use.
		_roll_velocity = direction
		
		#First parameter in .set is the Blend Position of the BlendSpace2D that is made in the AnimationTree
		#The second paramater is the movement direction. It is placed in an X,Y axis of BlendSpace2D so that it
		#can be checked to apply the right animation for the specific direction.
		_animation_tree.set("parameters/Idle/blend_position", direction)
		_animation_tree.set("parameters/Run/blend_position", direction)
		
		#This is to constrict direction when attacking/rolling. It takes the last blend position (X,Y) and will only
		#attack/roll on the final direction upon switching to set_Animation_Attack()/set_Animation_Roll.
		_animation_tree.set("parameters/Attack/blend_position", direction) 
		_animation_tree.set("parameters/Roll/blend_position", direction) 
		
		#It gets the current animation state and transitions it to the string name of the BlendSpace2D of AnimationTree
		_animation_state.travel("Run")
	else:
		_animation_state.travel("Idle")

func set_Animation_Player_State():
	if state == MOVE:
		if Input.is_action_just_pressed("btn_attack"):
			state = ATTACK
		if Input.is_action_just_pressed("btn_roll"):
			state = ROLL

#Note: If you attack upon start, the direc	tion will be "up" instead of your default of where you are facing.
func set_Animation_Attack():
	_velocity = Vector2.ZERO
	_animation_state.travel("Attack")

func set_Animation_Roll(delta):
	_velocity = _roll_velocity * ROLL_MAX_SPEED
	move()
	_animation_state.travel("Roll")

#This is for the AnimationPlayer
func attack_Finished():
	state = MOVE

func roll_finished():
	_velocity = _velocity * 0.8
	state = MOVE
