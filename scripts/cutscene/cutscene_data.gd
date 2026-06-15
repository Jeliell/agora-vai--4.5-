class_name CutsceneData
extends Resource

# Lista ordenada de falas que compõem a cutscene
@export var falas: Array[Fala] = []

# Para onde ir quando a cutscene terminar
@export var cena_seguinte: String = ""
