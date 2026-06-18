extends StaticBody2D

@export var cena_destino: String = ""
@export var eh_botao_sair: bool = false
@export var reseta_progresso: bool = false

var player_em_cima: bool = false

func _ready() -> void:
    # Opcional: configurar o texto aqui se necessário
    pass 

func _process(_delta: float) -> void:
    if player_em_cima and Input.is_action_just_pressed("ui_accept"):
        executar_acao()

func executar_acao() -> void:
    if eh_botao_sair:
        get_tree().quit()
    elif cena_destino != "":
        if reseta_progresso:
            # Certifique-se de que o script Configuracao existe no projeto
            if ResourceLoader.exists("res://scripts/configuracao.gd"):
                Configuracao.resetar_progresso()
        get_tree().change_scene_to_file(cena_destino)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jogador"):
        player_em_cima = true
        # Verifica se o Label existe antes de tentar mudar a cor
        if has_node("Label"):
            $Label.modulate = Color(2, 2, 0)
        position.y += 2

func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("jogador"):
        player_em_cima = false
        if has_node("Label"):
            $Label.modulate = Color(1, 1, 1)
        position.y -= 2


func _on_area_deteccao_body_entered(body: Node2D) -> void:
    pass # Replace with function body.


func _on_area_deteccao_body_exited(body: Node2D) -> void:
    pass # Replace with function body.
