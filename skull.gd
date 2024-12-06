extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		ScoreManager.add_score(1)  # Incrementa 1 ponto
		ScoreManager.total_score += 1  # Ou o valor correspondente.
		area.queue_free()
		$"../GameOver".show()
