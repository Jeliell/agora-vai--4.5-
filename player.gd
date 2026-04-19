extends CharacterBody2D

var speed = 220
var grav  = 15
var _posicao_inicial: Vector2
var _anim_timer: float = 0.0
var _anim_velocidade: float = 0.15  # segundos por frame — diminui para animar mais rápido

func _ready() -> void:
	add_to_group("jogador")
	_posicao_inicial = global_position

func resetar() -> void:
	global_position = _posicao_inicial
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += grav

	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$Sprite2D.flip_h = false
		_animar(delta)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$Sprite2D.flip_h = true
		_animar(delta)
	else:
		velocity.x = 0
		$Sprite2D.frame = 0  # frame parado

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y -= 500

	move_and_slide()

func _animar(delta: float) -> void:
	_anim_timer += delta
	if _anim_timer >= _anim_velocidade:
		_anim_timer = 0.0
		$Sprite2D.frame = ($Sprite2D.frame + 1) % 2  # alterna entre frame 0 e 1
