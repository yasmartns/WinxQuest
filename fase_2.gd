extends Node

var flor : PackedScene = load("res://Flor.tscn")
var confetti : PackedScene = load("res://ConfettiParticles.tscn")
var besouro : PackedScene = load("res://besouro.tscn")
var inimigo2 : PackedScene = load("res://inimigo2.tscn")
@onready var timer := $Timer as Timer
var used_positions : Array = []


var min_positions : Vector2 = Vector2(20, 176)
var max_positions : Vector2 = Vector2(520, 756)
var level : int = 1
var game_over : bool
var health : float = 10000
var decrease_health_speed : float = 750

func _process(delta):
	if health > 0:
		health -= delta * decrease_health_speed
		$UI/HealthBar.value = health
	else:
		show_game_over()

func _ready():
	instantiate_flor()
	instantiate_besouro()
	instantiate_inimigo2()
	
func generate_unique_position() -> Vector2:
	var position : Vector2
	var max_attempts : int = 100  # Limite de tentativas para evitar loop infinito
	
	for attempt in range(max_attempts):
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		position = Vector2(random_x, random_y)
		
		if not position in used_positions:
			used_positions.append(position)
			return position  # Retorna imediatamente após encontrar uma posição válida

	# Fallback: retorna uma posição padrão caso o loop não encontre uma posição
	return min_positions



func level_passed() -> void:
	health = 10000
	level += 1
	$UI/LevelLabel.text = "Level: " + str(level)
	instantiate_flor()
	instantiate_confetti()
	reset_besouro() # Remove e recria as caveiras ao passar de nível
	
func instantiate_besouro() -> void:
	for i in range(1): 
		var besouro_instance : Area2D = besouro.instantiate()
		besouro_instance.position = generate_unique_position()
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		besouro_instance.position = Vector2(random_x, random_y)
		besouro_instance.name = "Besouro" # Nomeia as instâncias para facilitar a identificação
		add_child(besouro_instance)
		

func reset_besouro() -> void:
	# Remove todas as caveiras existentes
	for child in get_children():
		if child.name == "Besouro":
			child.queue_free()
	
	# Instancia novas caveiras
	instantiate_besouro()

func show_game_over():
	$GameOver.show()
	game_over = true
	$Timer.stop()
	
func instantiate_flor() -> void:
	for i in range(level):
		var flor_instance : Area2D = flor.instantiate()
		flor_instance.position = generate_unique_position()
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		flor_instance.position = Vector2(random_x, random_y)
		call_deferred("add_child", flor_instance)

func instantiate_confetti() -> void:
	var confetti_instance : CPUParticles2D = confetti.instantiate()
	add_child(confetti_instance)
	confetti_instance.emitting = true
	
func instantiate_inimigo2() -> void:
	for i in range(1): 
		var inimigo2_instance : Area2D = inimigo2.instantiate()
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		inimigo2_instance.position = Vector2(random_x, random_y)
		inimigo2_instance.name = "inimigo2" # Nomeia as instâncias para facilitar a identificação
		add_child(inimigo2_instance)
	
func reset_inimigo2() -> void:
	# Remove todas as caveiras existentes
	for child in get_children():
		if child.name == "inimigo2":
			child.queue_free()
	
	# Instancia novas caveiras
	instantiate_inimigo2()


func _on_timer_timeout() -> void:
	var final_score = ScoreManager.total_score
	$FinalMessage/ScoreLabel.text = "Score Final: " + str(final_score)
	$FinalMessage.show()
	
func reset_game():
	ScoreManager.total_score = 0
