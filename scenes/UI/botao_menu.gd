extends Button

@export_file("*.tscn") var cena_destino: String = ""
@export var eh_botao_sair: bool = false

func _ready():
	focus_mode = FOCUS_ALL

# --- SINAIS DO SENSOR FÍSICO (Area2D) ---
func _on_area_2d_body_entered(body):
	if body.is_in_group("jogador"):
		modulate = Color(1.5, 1.5, 0) # Brilha apenas com o patinho
		grab_focus()

func _on_area_2d_body_exited(body):
	if body.is_in_group("jogador"):
		modulate = Color(1, 1, 1) # Volta ao normal
		release_focus()

# --- QUANDO APERTA ENTER ---
func _on_pressed():
	if eh_botao_sair:
		get_tree().quit()
	elif cena_destino != "": 
		get_tree().change_scene_to_file(cena_destino)
	# Nota: Se cena_destino estiver vazia (como nas Fases), ele não faz nada aqui.
	# Ele deixa o script principal (selecionar_fase.gd) assumir o controle!
