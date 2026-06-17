extends CanvasLayer

# Process Mode = "When Paused" no Inspector (essencial!)

func _ready() -> void:
	visible = false

func abrir() -> void:
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func fechar() -> void:
	visible = false
	get_tree().paused = false

func _on_botao_continuar_pressed() -> void:
	fechar()

func _on_botao_reiniciar_pressed() -> void:
	get_tree().paused = false
	var n: int = Configuracao.fase_atual
	get_tree().change_scene_to_file("res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn")

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
