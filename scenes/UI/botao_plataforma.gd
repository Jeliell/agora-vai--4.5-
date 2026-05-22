extends StaticBody2D

@export_group("Configurações do Botão")
@export var texto_do_botao: String = "Botão"
@export_file("*.tscn") var cena_destino: String
@export var eh_botao_sair: bool = false
@export var reseta_progresso: bool = false

var player_em_cima: bool = false

func _ready() -> void:
	$Label.text = texto_do_botao
	# Conectando os sinais via código para evitar erros
	$AreaDeteccao.body_entered.connect(_on_body_entered)
	$AreaDeteccao.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_em_cima and Input.is_action_just_pressed("ui_accept"):
		executar_acao()

func executar_acao() -> void:
	if eh_botao_sair:
		get_tree().quit()
	elif cena_destino != "":
		if reseta_progresso:
			Configuracao.resetar_progresso()
		get_tree().change_scene_to_file(cena_destino)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_em_cima = true
		$Label.modulate = Color(2, 2, 0) # Brilha amarelo
		position.y += 2 # Efeito de clique

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_em_cima = false
		$Label.modulate = Color(1, 1, 1) # Volta ao normal
		position.y -= 2
