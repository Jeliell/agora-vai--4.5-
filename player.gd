extends CharacterBody2D

var speed: int = 220
var grav: int = 15
var jump_force: int = -500
var _posicao_inicial: Vector2
var _anim_timer: float = 0.0
var _anim_velocidade: float = 0.1

# ── Stamina ───────────────────────────────────────
var stamina_ativa: bool = false
var stamina: float = 100.0
var stamina_max: float = 100.0
var stamina_custo_correr: float = 15.0
var stamina_custo_pular: float = 10.0
var stamina_recuperacao: float = 20.0
var speed_cansado: int = 80
var barra_stamina: ProgressBar = null
# ─────────────────────────────────────────────────

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
	stamina = stamina_max
	_atualizar_barra()

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y += grav
	else:
		velocity.y = 0

	var velocidade_atual: int = speed_cansado if (stamina_ativa and stamina <= 0) else speed

	# Movimentação horizontal
	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * velocidade_atual
		$Sprite2D.flip_h = (direction < 0)
		_animar(delta, "andar")
		if stamina_ativa:
			stamina -= stamina_custo_correr * delta
			stamina = max(stamina, 0.0)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		_animar(delta, "parado")
		if stamina_ativa:
			stamina += stamina_recuperacao * delta
			stamina = min(stamina, stamina_max)

	# Pulo
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force
		if stamina_ativa:
			stamina -= stamina_custo_pular
			stamina = max(stamina, 0.0)

	move_and_slide()

	if stamina_ativa:
		_atualizar_barra()

func _atualizar_barra() -> void:
	if barra_stamina:
		barra_stamina.value = stamina

func _animar(delta: float, estado: String) -> void:
	_anim_timer += delta
	if _anim_timer >= _anim_velocidade:
		_anim_timer = 0.0

		match estado:
			"parado":
				# Linha 0 do spritesheet — 4 frames idle
				$Sprite2D.frame = ($Sprite2D.frame + 1) % 4
			"andar":
				# Linha 1 do spritesheet — frames 24 a 29
				var frame_inicial: int = 24
				var total_frames_andar: int = 6
				var frame_atual: int = $Sprite2D.frame

				if frame_atual < frame_inicial or frame_atual >= frame_inicial + total_frames_andar:
					$Sprite2D.frame = frame_inicial
				else:
					$Sprite2D.frame = frame_inicial + ((frame_atual - frame_inicial + 1) % total_frames_andar)
