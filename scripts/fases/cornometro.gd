extends Label

signal tempo_esgotado

var valor: float = 30.0
var tempo: float = 0.0

# Controlado pelo debug (F9) — quando true, o tempo para de contar
var tempo_travado: bool = false

func _ready() -> void:
	valor = Configuracao.get_tempo()
	self.text = str(int(valor))

func _process(delta: float) -> void:
	# Se o tempo estiver travado (debug), não conta
	if tempo_travado:
		return

	tempo += delta
	if tempo >= 1.0:
		valor -= 1
		self.text = str(int(valor))
		tempo = 0.0

		if valor <= 0:
			valor = Configuracao.get_tempo()
			emit_signal("tempo_esgotado")
