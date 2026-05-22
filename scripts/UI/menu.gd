extends Node2D

# --- VARIÁVEIS PARA A GARÇA ---
@onready var ponto_origem = $PontoOrigem # Adicione um nó Marker2D chamado "PontoOrigem" na sua cena!
var resgatando: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Dica: se o menu for 100% controlável pelo patinho depois, 
	# você pode mudar para Input.MOUSE_MODE_HIDDEN para esconder o mouse!

# --- FUNÇÕES ORIGINAIS DO SEU JOGO (MANTIDAS) ---

func _on_botao_jogar_pressed() -> void:
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/fases/fase1/fase1.tscn")

func _on_botao_selecionar_fase_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/selecionar_fase.tscn")

func _on_botao_dificuldade_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/selecionar_dificuldade.tscn")

func _on_botao_sair_pressed() -> void:
	if OS.has_feature("editor"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	else:
		get_tree().quit()

# --- MECÂNICA DE RESGATE DA GARÇA ---

# No topo do seu script menu.gd, certifique-se de que estas variáveis existem:
@onready var garca_patrulheira = $GarcaMenu # O nome aqui deve ser igual ao nome do nó da Garça na sua árvore de cenas!
@onready var ponto_origem_marcador = $PontoOrigem

# --- Suas funções antigas de botões continuam aqui ...

# --- ESTA É A FUNÇÃO QUE ESTAVA USANDO O SVG ANTIGAMENTE ---
func _on_zona_de_queda_body_entered(body: Node2D) -> void:
	# 1. Verifica se quem caiu foi o jogador (patinho) e se já não estamos resgatando
	if body.is_in_group("jogador") and not resgatando:
		resgatando = true # Ativa o estado de resgate
		
		# 2. Congela a física do patinho (para de cair e para o controle do jogador)
		if "velocity" in body:
			body.velocity = Vector2.ZERO
		body.set_physics_process(false) 
		
		# 3. MÁGICA: Em vez de criar um Sprite novo (SVG), nós chamamos a Garça que já está na tela!
		if garca_patrulheira != null:
			# Chama a função que criamos no script da Garça, passando o patinho e onde ele deve ir
			garca_patrulheira.iniciar_resgate(body, ponto_origem_marcador)
		else:
			push_error("ERRO: O nó 'GarcaMenu' não foi encontrado na cena do Menu. Verifique o nome!")
