extends Node2D

@onready var garca_patrulheira = $GarcaMenu
@onready var ponto_origem = $PontoOrigem
@onready var botao_jogar = $BotaoJogar

var resgatando: bool = false

func _on_zona_de_queda_body_entered(body: Node2D) -> void:
    print("Algo caiu na zona de queda: ", body.name) # Print para teste!
    
    if body.name == "player" and not resgatando:
        resgatando = true
        var pos_segura = ponto_origem.global_position
        body.velocity = Vector2.ZERO
        body.set_physics_process(false)
        garca_patrulheira.iniciar_resgate(body, pos_segura)

func _on_zona_de_queda_area_entered(area: Area2D) -> void:
    pass

const FASES = {
    1: "res://scenes/fases/fase1/fase1.tscn",
    2: "res://scenes/fases/fase2/fase2.tscn",
    3: "res://scenes/fases/fase3/fase3.tscn",
    4: "res://scenes/fases/fase4/fase4.tscn",
}

var fase_selecionada: int = -1

@onready var painel_fases: Control  = $PainelFases
@onready var painel_niveis: Control = $PainelNiveis
@onready var label_fase_titulo: Label = $Fases

func _ready() -> void:
    # Mostra as Fases e liga a física/interação delas
    painel_fases.visible = true
    painel_fases.process_mode = Node.PROCESS_MODE_INHERIT
    
    # Esconde os Níveis e desliga eles da tomada
    painel_niveis.visible = false
    painel_niveis.process_mode = Node.PROCESS_MODE_DISABLED

func selecionar_fase(fase: int) -> void:
    fase_selecionada = fase
    label_fase_titulo.text = "Fase " + str(fase)
    
    # Desliga totalmente o painel de Fases (Fica invisível e sem colisão)
    painel_fases.visible = false
    painel_fases.process_mode = Node.PROCESS_MODE_DISABLED
    
    # Liga totalmente o painel de Níveis (Fica visível e com colisão)
    painel_niveis.visible = true
    painel_niveis.process_mode = Node.PROCESS_MODE_INHERIT

func _on_botao_voltar_pressed() -> void:
    # Desliga totalmente o painel de Níveis
    painel_niveis.visible = false
    painel_niveis.process_mode = Node.PROCESS_MODE_DISABLED
    
    # Liga totalmente o painel de Fases
    painel_fases.visible = true
    painel_fases.process_mode = Node.PROCESS_MODE_INHERIT

func selecionar_nivel(nivel: int) -> void:
    Configuracao.nivel_atual_da_fase = nivel
    get_tree().change_scene_to_file(FASES[fase_selecionada])

func _on_botao_menu_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")

# --- PLATAFORMAS DE FASES ---
func _on_botao_fase_1_pressed() -> void:
    selecionar_fase(1)

func _on_botao_fase_2_pressed() -> void:
    selecionar_fase(2)
    
func _on_botao_fase_3_pressed() -> void:
    selecionar_fase(3)
    
func _on_botao_fase_4_pressed() -> void:
    selecionar_fase(4)

# --- PLATAFORMAS DE NÍVEIS (Dentro do painel de Níveis) ---
func _on_botao_nivel_1_pressed() -> void:
    selecionar_nivel(1)

func _on_botao_nivel_2_pressed() -> void:
    selecionar_nivel(2)
    
func _on_botao_nivel_3_pressed() -> void:
    selecionar_nivel(3)
