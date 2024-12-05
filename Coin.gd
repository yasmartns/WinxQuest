extends Area2D

func _on_animation_player_animation_finished(_anim_name : String):
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("Player"):
		$AnimationPlayer.play("CoinCollected")
		$CollisionShape2D.call_deferred("set_disabled", true)
