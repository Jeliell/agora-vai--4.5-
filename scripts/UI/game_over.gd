extends CanvasLayer

func _ready() -> void:
	visible = false

# Chamado pelo world_base quando as vidas acabam
func abrir() -> void:
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_reiniciar_pressed() -> void:
	get_tree().paused = false
	Configuracao.nivel_atual_da_fase = 1
	var n: int = Configuracao.fase_atual
	get_tree().change_scene_to_file("res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn")

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
