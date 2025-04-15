extends Area2D

var direction : Vector2 = Vector2.ZERO
var min_positions : Vector2 = Vector2(20, 176)
var max_positions : Vector2 = Vector2(520, 756)
var speed : int = 350
var score : int
var coins_collected_in_level : int
var can_move : bool = true

func _process(delta):
	if get_parent().game_over:
		$AnimatedSprite2D.animation = "Death"
		return

	if can_move:
		handle_input()
		position += direction.normalized() * speed * delta
		position.x = clamp(position.x, min_positions.x, max_positions.x)
		position.y = clamp(position.y, min_positions.y, max_positions.y)
	else:
		$AnimatedSprite2D.animation = "Idle"


func handle_input():
	direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		$AnimatedSprite2D.animation = "Back"

	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		$AnimatedSprite2D.animation = "Front"

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_h = true

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_h = false

	if direction == Vector2.ZERO:
		$AnimatedSprite2D.animation = "Idle"


func _on_area_entered(area):
	if area.is_in_group("Coin"):
		coins_collected_in_level += 1
		score += 1
		get_parent().get_node("UI/CoinsLabel").text = "Flores: " + str(score)
		get_parent().get_node("UI/CoinsLabelAnimationPlayer").play("ScoreIncreased")

		if coins_collected_in_level == get_parent().level:
			coins_collected_in_level = 0
			get_parent().level_passed()
