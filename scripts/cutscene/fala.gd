class_name Fala
extends Resource

# Quem está falando: "pato" (esquerda) ou "garca" (direita)
@export_enum("pato", "garca") var personagem: String = "pato"

# Texto da fala
@export_multiline var texto: String = ""
