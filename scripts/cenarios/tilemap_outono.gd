extends TileMapLayer

# Tempo entre pisar e o tile cair
@export var tempo_para_cair: float = 1.0
# Tempo que o tile fica sumido antes de ressurgir
@export var tempo_para_voltar: float = 3.0
# Largura do jogador em pixels (ajuste se o pato for maior/menor)
@export var largura_jogador: float = 16.0

@export var celulas_que_caem: Array[Vector2i] = [
	Vector2i(7, 11), Vector2i(8, 11), Vector2i(9, 11),
	Vector2i(1, 8), Vector2i(2, 8), Vector2i(3, 8),
	Vector2i(4, 4), Vector2i(5, 4), Vector2i(6, 4),
	Vector2i(25, 4), Vector2i(26, 4), Vector2i(27, 4),
	Vector2i(30, 8), Vector2i(31, 8), Vector2i(32, 8),
	Vector2i(24, 11), Vector2i(25, 11), Vector2i(26, 11),
]

var _tiles_ocupados: Dictionary = {}
var _tiles_originais: Dictionary = {}

func _ready() -> void:
	for celula in celulas_que_caem:
		var source := get_cell_source_id(celula)
		if source != -1:
			_tiles_originais[celula] = {
				"source": source,
				"atlas": get_cell_atlas_coords(celula),
				"alt": get_cell_alternative_tile(celula),
			}

func _physics_process(_delta: float) -> void:
	var jogadores := get_tree().get_nodes_in_group("jogador")
	if jogadores.is_empty():
		return

	var player = jogadores[0]
	if not player.is_on_floor():
		return

	var base_y: float = player.global_position.y + 8
	var metade: float = largura_jogador / 2.0
	var esquerda: float = player.global_position.x - metade
	var direita: float = player.global_position.x + metade

	# Coleta todas as células únicas que o jogador cobre, varrendo
	# da borda esquerda à direita em passos de meio tile (8px)
	# Garante detectar qualquer tile tocado, não importa quão pouco
	var celulas_detectadas: Dictionary = {}
	var px: float = esquerda
	while px <= direita:
		var celula := local_to_map(to_local(Vector2(px, base_y)))
		celulas_detectadas[celula] = true
		px += 8.0
	# Garante incluir a borda direita exata
	celulas_detectadas[local_to_map(to_local(Vector2(direita, base_y)))] = true

	for celula in celulas_detectadas:
		if celula in celulas_que_caem and not _tiles_ocupados.has(celula):
			if get_cell_source_id(celula) != -1:
				_tiles_ocupados[celula] = true
				_iniciar_ciclo(celula)

func _iniciar_ciclo(celula: Vector2i) -> void:
	await get_tree().create_timer(tempo_para_cair).timeout

	set_cell(celula, -1)
	notify_runtime_tile_data_update()

	await get_tree().create_timer(tempo_para_voltar).timeout

	if _tiles_originais.has(celula):
		var orig = _tiles_originais[celula]
		set_cell(celula, orig["source"], orig["atlas"], orig["alt"])
		notify_runtime_tile_data_update()

	_tiles_ocupados.erase(celula)
