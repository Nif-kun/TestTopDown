extends Area2D

const hit_effect = preload("res://worlds/Effects/HitEffect.tscn")
export var show_hit = true

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = hit_effect.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = global_position
