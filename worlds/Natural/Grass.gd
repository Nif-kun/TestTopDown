extends Node2D

#Loads the scene file once instead of loading it in death_effect which is redone everytime the area is entered.
const grass_effect = preload("res://worlds/Effects/GrassEffect.tscn")

#When the area is entered by a selected collision mask, this method runs.
func _on_Hurtbox_area_entered(area):
	death_effect()
	queue_free()

func death_effect():
	#Gets the instance of grass_effect and applies to self.
	var grass_Effect = grass_effect.instance()
	
	#Gets the parent of the node and adds a child node: "grass_effect"
	get_parent().add_child(grass_Effect)
	
	#The "grass_effect"'s location is given the same location of the class/script's node.
	#In this case, the Grass node.
	grass_Effect.global_position = global_position
	
