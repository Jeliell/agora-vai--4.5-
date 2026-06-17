extends Node2D

# Cutscene de diálogo (visual novel).
# Pato animado à esquerda (toca "run_aside"), garça à direita.
@export var dados: CutsceneData = null

@onready var label_texto: Label   = $CaixaDialogo/LabelTexto
@onready var label_nome: Label    = $CaixaDialogo/LabelNome
@onready var retrato_pato: AnimatedSprite2D = $RetratoPato
@onready var retrato_garca: Node2D          = $RetratoGarca   # Sprite2D ou AnimatedSprite2D

var _indice: int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Inicia a animação de corrida do pato (em loop)
	if is_instance_valid(retrato_pato) and retrato_pato.sprite_frames \
	   and retrato_pato.sprite_frames.has_animation("run_aside"):
		retrato_pato.play("run_aside")

	# Quando tiver a arte da garça animada, descomente e ajuste o nome:
	# if retrato_garca is AnimatedSprite2D:
	#     retrato_garca.play("nome_da_animacao")

	if Configuracao.cutscene_atual != null:
		dados = Configuracao.cutscene_atual

	if dados == null or dados.falas.is_empty():
		_terminar()
		return

	_mostrar_fala()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or \
	   (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_avancar()

func _avancar() -> void:
	_indice += 1
	if _indice >= dados.falas.size():
		_terminar()
	else:
		_mostrar_fala()

func _mostrar_fala() -> void:
	var fala: Fala = dados.falas[_indice]
	label_texto.text = fala.texto

	if fala.personagem == "pato":
		label_nome.text = "Pato"
	else:
		label_nome.text = "Garça"

	_destacar_falante(fala.personagem)

# Acende quem está falando e escurece o outro
func _destacar_falante(falante: String) -> void:
	var pato_ativo: bool = falante == "pato"
	if is_instance_valid(retrato_pato):
		retrato_pato.modulate  = Color(1, 1, 1, 1) if pato_ativo else Color(0.45, 0.45, 0.45, 1)
	if is_instance_valid(retrato_garca):
		retrato_garca.modulate = Color(0.45, 0.45, 0.45, 1) if pato_ativo else Color(1, 1, 1, 1)

func _terminar() -> void:
	var destino: String = dados.cena_seguinte if dados else ""
	if destino == "":
		Configuracao.resetar_progresso()
		get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
	else:
		get_tree().change_scene_to_file(destino)
