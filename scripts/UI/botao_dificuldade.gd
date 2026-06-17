extends Button

# Isso aparece no seu Inspetor. Configure cada botão lá!
@export_file("res://scenes/UI/selecionar_dificuldade.tscn") var cena_destino: String
@export var eh_botao_sair: bool = false

func _ready():
    # Prepara o botão para aceitar foco do teclado/patinho
    focus_mode = FOCUS_ALL

# Chamado quando o botão ganha foco (patinho pisou em cima)
func _on_focus_entered():
    modulate = Color(1.5, 1.5, 0) # Brilha amarelo

# Chamado quando o botão perde foco (patinho saiu)
func _on_focus_exited():
    modulate = Color(1, 1, 1) # Volta ao normal

# Chamado ao apertar Enter
func _on_pressed():
    if eh_botao_sair:
        get_tree().quit()
    elif cena_destino != "res://scenes/UI/selecionar_dificuldade.tscn":
        get_tree().change_scene_to_file(cena_destino)
    else:
        print("Dificuldade ", name, " não tem destino configurado!")

func _on_area_jogar_body_entered(body):
    if body.is_in_group("jogador"):
        grab_focus()

func _on_area_jogar_body_exited(body):
    if body.is_in_group("jogador"):
        release_focus()
