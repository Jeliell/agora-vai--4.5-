extends TileMapLayer

# Tempo entre o jogador pisar no tile e ele cair (em segundos)
@export var tempo_para_cair: float = 1.0

# Coordenadas das plataformas que devem cair
@export var celulas_que_caem: Array[Vector2i] = [
	# Plataforma 1
	Vector2i(7, 11), Vector2i(8, 11), Vector2i(9, 11),
	# Plataforma 2
	Vector2i(1, 8), Vector2i(2, 8), Vector2i(3, 8),
	# Plataforma 3
	Vector2i(4, 4), Vector2i(5, 4), Vector2i(6, 4),
	# Plataforma 4
	Vector2i(25, 4), Vector2i(26, 4), Vector2i(27, 4),
	# Plataforma 5
	Vector2i(30, 8), Vector2i(31, 8), Vector2i(32, 8),
	# Plataforma 6
	Vector2i(24, 11), Vector2i(25, 11), Vector2i(26, 11),
]

# Guarda os tiles que já estão programados para cair
var _tiles_caindo: Dictionary = {}

func _physics_process(_delta: float) -> void:
	var jogadores := get_tree().get_nodes_in_group("jogador")
	if jogadores.is_empty():
		return

	var player = jogadores[0]

	if not player.is_on_floor():
		return

	var pos_pes: Vector2 = player.global_position + Vector2(0, 8)
	var celula := local_to_map(to_local(pos_pes))

	if not celula in celulas_que_caem:
		return

	if get_cell_source_id(celula) == -1:
		return

	if not _tiles_caindo.has(celula):
		_tiles_caindo[celula] = true
		_iniciar_queda(celula)

func _iniciar_queda(celula: Vector2i) -> void:
	await get_tree().create_timer(tempo_para_cair).timeout

	set_cell(celula, -1)
	notify_runtime_tile_data_update()

	_tiles_caindo.erase(celula)
