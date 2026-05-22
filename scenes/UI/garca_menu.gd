extends CharacterBody2D

# --- NOVAS VARIÁVEIS PARA O ENCAIXE PERFEITO DO BICO ---
# Adicionei estas variáveis para você ajustar na Godot sem precisar mexer no código!
@export var distancia_corpo_corpo: float = 5.0 # Quão perto a garça chega do patinho no mergulho inicial (center to center)
@export var offset_bico_transporte: Vector2 = Vector2(0, 10) # Ajuste visual FINO do bico na pose 'voando' em relação ao centro da garça.

@export var velocidade_caminhada: float = 30.0
@export var limite_esquerdo: float = 100.0 # Ajuste no Inspetor do Menu
@export var limite_direito: float = 800.0  # Ajuste no Inspetor do Menu

var em_patrulha: bool = true
var direcao: int = 1

@onready var animacao = $AnimatedSprite2D

func _ready():
	# Verificação de segurança para o nó de animação
	if animacao == null:
		push_error("ERRO: O nó 'AnimatedSprite2D' não foi encontrado na GarcaMenu!")
		set_physics_process(false)
		return
	animacao.play("andando")

func _physics_process(_delta):
	if em_patrulha:
		patrulhar()

func patrulhar():
	velocity.x = velocidade_caminhada * direcao
	velocity.y = 0 
	move_and_slide()
	
	if animacao == null: return # Segurança extra
	
	if direcao == 1:
		animacao.flip_h = false 
	else:
		animacao.flip_h = true

	if global_position.x >= limite_direito and direcao == 1:
		direcao = -1
	elif global_position.x <= limite_esquerdo and direcao == -1:
		direcao = 1

func iniciar_resgate(alvo: Node2D, ponto_origem: Marker2D):
	if alvo == null or ponto_origem == null: return
	
	em_patrulha = false
	velocity = Vector2.ZERO # Para o movimento do move_and_slide imediatamente
	
	# 1. Salva onde ela estava para poder voltar depois
	var posicao_patrulha = global_position
	
	# 2. Prepara a animação
	animacao.play("voando")
	
	var tween_ida = get_tree().create_tween()
	
	# === ETAPA A: O Mergulho Direto ===
	# Calculamos a posição exata do patinho AGORA. 
	# O "- Vector2(0, distancia_corpo_corpo)" garante que ela pare um pouco acima dele.
	var destino_mergulho = alvo.global_position - Vector2(0, distancia_corpo_corpo)
	
	tween_ida.tween_property(self, "global_position", destino_mergulho, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Feedback visual de pegando
	tween_ida.tween_callback(func(): animacao.play("pegando"))
	tween_ida.tween_interval(0.2)
	
	# === ETAPA B: O Transporte ===
	tween_ida.tween_callback(func(): animacao.play("voando"))
	
	# Move ambos para o ponto de origem (o Marker2D)
	tween_ida.tween_property(alvo, "global_position", ponto_origem.global_position, 1.2)
	tween_ida.parallel().tween_property(self, "global_position", ponto_origem.global_position + offset_bico_transporte, 1.2)
	
	# === ETAPA C: Soltar e Voltar ===
	tween_ida.tween_callback(func():
		alvo.set_physics_process(true)
		
		if alvo.get_parent() and "resgatando" in alvo.get_parent():
			alvo.get_parent().resgatando = false 
		
		# Voa de volta para a linha de patrulha
		var tween_volta = get_tree().create_tween()
		tween_volta.tween_property(self, "global_position", posicao_patrulha, 0.8) 
		tween_volta.tween_callback(func():
			em_patrulha = true
			animacao.play("andando")
		)
	)
	if alvo == null or ponto_origem == null or animacao == null: return # Segurança
	
	em_patrulha = false
	velocity = Vector2.ZERO 
	
	# Salva a posição exata de onde ela estava patrulhando
	var posicao_patrulha = global_position
	
	animacao.play("voando")
	
	var tween_ida = get_tree().create_tween()
	
	# === ETAPA A: O Mergulho (Corrigido) ===
	# Agora ela mergulha até que os CORPOS cheguem perto usando a variável que criamos
	tween_ida.tween_property(self, "global_position", alvo.global_position - Vector2(0, distancia_corpo_corpo), 1.0).set_trans(Tween.TRANS_QUAD)
	
	# CALLBACK: Pose de bico curvado (Neste momento, a pose curvada deve VISUALMENTE tocar o patinho)
	tween_ida.tween_callback(func(): animacao.play("pegando"))
	tween_ida.tween_interval(0.2)
	
	# === ETAPA B: O Transporte com o Encaixe (Totalmente Reformulada) ===
	# Callback: Pose de voar novamente
	tween_ida.tween_callback(func(): animacao.play("voando"))
	
	# AQUI ESTÁ O SEGREDO DO ENCAIXE:
	# 1. Alvo (patinho) vai para o ponto final (Marker).
	tween_ida.tween_property(alvo, "global_position", ponto_origem.global_position, 1.5)
	
	# 2. Garça vai para o ponto final MAIS o offset do bico.
	# Isso garante que se a garça chegar no ponto final, o patinho (que está no ponto final)
	# estará exatamente alinhado com o bico dela.
	tween_ida.parallel().tween_property(self, "global_position", ponto_origem.global_position + offset_bico_transporte, 1.5)
	
	# === ETAPA C: A Soltura e Volta (Mantido) ===
	tween_ida.tween_callback(func():
		# Libera o patinho
		alvo.set_physics_process(true)
		
		# Libera o menu para novos resgates
		if alvo.get_parent() and "resgatando" in alvo.get_parent():
			alvo.get_parent().resgatando = false 
		
		# A garça voa de volta para casa
		var tween_volta = get_tree().create_tween()
		tween_volta.tween_property(self, "global_position", posicao_patrulha, 1.0) 
		tween_volta.tween_callback(func():
			em_patrulha = true
			animacao.play("andando")
		)
	)
