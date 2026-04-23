extends Label

signal tempo_esgotado

var valor = 30.0
var tempo = 0.0

func _ready():
	self.text = str(int(valor))

func _process(delta):
	tempo += delta
	if tempo >= 1.0:
		valor -= 1
		self.text = str(int(valor))
		tempo = 0.0

		if valor <= 0:
			valor = 30.0
			emit_signal("tempo_esgotado")
