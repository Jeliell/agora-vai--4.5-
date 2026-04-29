extends TileMapLayer

# Quanto menor, mais escorregadio (atrito ao soltar a tecla)
@export var gelo_atrito: float = 200.0
# Quanto menor, mais devagar acelera
@export var gelo_aceleracao: float = 400.0

func _physics_process(_delta: float) -> void:
	var jogadores := get_tree().get_nodes_in_group("jogador")
	if jogadores.is_empty():
		return

	var player = jogadores[0]

	# Aplica gelo sempre que o jogador estiver no chão deste tilemap
	# No ar mantém o comportamento padrão
	if player.is_on_floor():
		player.atrito_horizontal = gelo_atrito
		player.aceleracao_horizontal = gelo_aceleracao
	else:
		player.atrito_horizontal = -1.0
		player.aceleracao_horizontal = -1.0
