extends StaticBody2D

@export var cena_destino: String = ""
@export var eh_botao_sair: bool = false
@export var reseta_progresso: bool = false

var player_em_cima: bool = false

func _ready() -> void:
    # Opcional: configurar o texto aqui se necessário
    pass 

func _process(_delta: float) -> void:
    # Se o patinho está na plataforma e o Enter for pressionado
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
    else:
        # Aviso no terminal caso esqueça de preencher o Inspetor
        printerr("Atenção: A plataforma '", name, "' não tem cena de destino configurada!")

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jogador"):
        player_em_cima = true
        position.y += 2 # Efeito físico de afundar a plataforma
        
        # Feedback Visual: Muda a cor do Label para amarelo
        if has_node("Label"):
            $Label.modulate = Color(2, 2, 0)
            
        # Feedback Visual: Começa a animação de Pulsar!
        if has_node("Pulsar"):
            $Pulsar.play("pulsar")

func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("jogador"):
        player_em_cima = false
        position.y -= 2 # Plataforma volta a subir
        
        # Retira a cor amarela
        if has_node("Label"):
            $Label.modulate = Color(1, 1, 1)
            
        # Para a animação e reseta o tamanho do Label
        if has_node("Pulsar"):
            $Pulsar.stop()
            if has_node("Label"):
                $Label.scale = Vector2(1, 1) # Garante que o texto volte ao normal
