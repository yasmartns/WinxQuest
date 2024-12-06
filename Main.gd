extends Node

@export var coin : PackedScene
@export var confetti : PackedScene
var skull : PackedScene = load("res://skull.tscn")
var obstaculo : PackedScene = load("res://obstaculo.tscn")
@onready var timer := $Timer as Timer


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
	instantiate_coins()
	instantiate_skulls()
	instantiate_obstaculo()

func level_passed() -> void:
	health = 10000
	level += 1
	$UI/LevelLabel.text = "Level: " + str(level)
	instantiate_coins()
	instantiate_confetti()
	reset_skulls() # Remove e recria as caveiras ao passar de nível
	
func instantiate_skulls() -> void:
	for i in range(1): 
		var skull_instance : Area2D = skull.instantiate()
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		skull_instance.position = Vector2(random_x, random_y)
		skull_instance.name = "Skull" # Nomeia as instâncias para facilitar a identificação
		add_child(skull_instance)
		

func reset_skulls() -> void:
	# Remove todas as caveiras existentes
	for child in get_children():
		if child.name == "Skull":
			child.queue_free()
	
	# Instancia novas caveiras
	instantiate_skulls()

func show_game_over():
	$GameOver.show()
	game_over = true
	$Timer.stop()
	$MensageTimer.stop()
	$MensagemFase2.stop()
	
func instantiate_coins() -> void:
	for i in range(level):
		var coin_instance : Area2D = coin.instantiate()
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		coin_instance.position = Vector2(random_x, random_y)
		call_deferred("add_child", coin_instance)

func instantiate_confetti() -> void:
	var confetti_instance : CPUParticles2D = confetti.instantiate()
	add_child(confetti_instance)
	confetti_instance.emitting = true
	
func instantiate_obstaculo() -> void:
	for i in range(1): 
		var obstaculo_instance : Area2D = obstaculo.instantiate()
		var random_x : float = randf_range(min_positions.x, max_positions.x)
		var random_y : float = randf_range(min_positions.y, max_positions.y)
		obstaculo_instance.position = Vector2(random_x, random_y)
		obstaculo_instance.name = "Obstaculo" # Nomeia as instâncias para facilitar a identificação
		add_child(obstaculo_instance)
	
func reset_obstaculo() -> void:
	# Remove todas as caveiras existentes
	for child in get_children():
		if child.name == "Obstaculo":
			child.queue_free()
	
	# Instancia novas caveiras
	instantiate_obstaculo()
	
func _on_mensage_timer_timeout() -> void:
	$MensagemFase2.show()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Fase2.tscn")
