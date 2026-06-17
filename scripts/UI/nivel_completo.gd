extends CanvasLayer

func _ready() -> void:
	visible = false

# Chamado pelo world_base quando o nível é concluído
func abrir() -> void:
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_proximo_nivel_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(_caminho_fase_atual())

func _on_botao_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(_caminho_fase_atual())

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")

func _caminho_fase_atual() -> String:
	var n: int = Configuracao.fase_atual
	return "res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn"
