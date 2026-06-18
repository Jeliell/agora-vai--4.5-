extends Button

func _ready():
	# Prepara o botão para aceitar foco do teclado/patinho
	focus_mode = FOCUS_ALL

# Chamado quando o botão ganha foco (patinho pisou em cima)
func _on_focus_entered():
	modulate = Color(1.5, 1.5, 0) # Brilha amarelo

# Chamado quando o botão perde foco (patinho saiu)
func _on_focus_exited():
	modulate = Color(1, 1, 1) # Volta ao normal

func _on_area_jogar_body_entered(body):
	if body.is_in_group("player"):
		grab_focus()

func _on_area_jogar_body_exited(body):
	if body.is_in_group("player"):
	   release_focus()
