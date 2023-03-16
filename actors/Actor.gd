extends KinematicBody2D
class_name Actor

var _velocity = Vector2.ZERO
export var ACCELERATION = 600
export var MAX_SPEED = 80
export var FRICTION = 550

var _animation_tree = null 
var _animation_state = null
