extends Node2D

export var max_health = 1.0

#setget basically gets the changed value and applies to the method set_health
onready var health = max_health setget set_health 
signal no_health #Custom signal used by an actor.

#Parameter can be custom named, however it is required to have one.
#The "value" parameter contains the new value of health that was applied by setget
func set_health(value):
	health = value #The new value is then set on health since setget stops the main var from changing.
	if health <= 0:
		emit_signal("no_health") 
		#As the method suggests, it pings the signal that was made.
		#Anything within the signal will run. Example can be found in "Bat" script.
