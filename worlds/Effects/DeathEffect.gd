extends AnimatedSprite
class_name DeathEffect

func _ready():
#	(signal type, object, method)
	#animation finished is a signal; queu_free is a method; and self is this class (itself)
	connect("animation_finished", self, "queue_free")
	frame = 0 #This is a property, basically sets the frame of the animation.
	
	#play is a method of the AnimatedSprite node, which as the names suggest, plays the animation.
	#"Animate" is the name of the SpriteFrame's animation within the AnimatedSprite.
	#Note: "Animate" as a name needs to be the same in the AnimatedSprite. This should be constant and inheritable.
	play("Animate")
