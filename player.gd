extends CharacterBody2D

var speed = 220
var grav  = 20
var jump_force = -500
var _posicao_inicial: Vector2
var _anim_timer: float = 0.0
var _anim_velocidade: float = 0.1

func _ready() -> void:
	add_to_group("jogador")
	_posicao_inicial = global_position
	
	# Proteção contra duplicidade
	var jogadores = get_tree().get_nodes_in_group("jogador")
	if jogadores.size() > 1 and jogadores[0] != self:
		queue_free()
		return

func resetar() -> void:
	global_position = _posicao_inicial
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y += grav
	else:
		velocity.y = 0

	# Movimentação Horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		$Sprite2D.flip_h = (direction < 0)
		_animar(delta, "andar")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		_animar(delta, "parado")

	# Pulo
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force

	move_and_slide()

func _animar(delta: float, estado: String) -> void:
	_anim_timer += delta
	if _anim_timer >= _anim_velocidade:
		_anim_timer = 0.0
		
		match estado:
			"parado":
				# A primeira linha (Vframe 0) tem a animação Idle
				# Vamos usar os primeiros 4 frames para o Idle
				$Sprite2D.frame = ($Sprite2D.frame + 1) % 4
			"andar":
				# A segunda linha (Vframe 1) começa no frame 24
				# Vamos usar os frames 24 a 29 para a animação de andar
				var frame_inicial = 24
				var total_frames_andar = 6
				var frame_atual = $Sprite2D.frame
				
				if frame_atual < frame_inicial or frame_atual >= frame_inicial + total_frames_andar:
					$Sprite2D.frame = frame_inicial
				else:
					$Sprite2D.frame = frame_inicial + ((frame_atual - frame_inicial + 1) % total_frames_andar)
