extends CharacterBody2D

@export var distancia_corpo_corpo: float = 5.0
@export var offset_bico_transporte: Vector2 = Vector2(0, 10)
@export var velocidade_caminhada: float = 30.0
@export var limite_esquerdo: float = 100.0
@export var limite_direito: float = 800.0

var em_patrulha: bool = true
var direcao: int = 1

@onready var animacao = $AnimatedSprite2D
@onready var colisao = $CollisionShape2D # <-- REFERÊNCIA À COLISÃO

func _ready():
    animacao.play("andando")

func _physics_process(_delta):
    if em_patrulha:
        patrulhar()

func patrulhar():
    velocity.x = velocidade_caminhada * direcao
    velocity.y = 0
    move_and_slide()
    animacao.flip_h = (direcao == -1)

    if global_position.x >= limite_direito and direcao == 1:
        direcao = -1
    elif global_position.x <= limite_esquerdo and direcao == -1:
        direcao = 1

func iniciar_resgate(alvo: Node2D, posicao_destino: Vector2):
    if alvo == null: return
    
    em_patrulha = false
    velocity = Vector2.ZERO
    
    # Desliga a colisão da garça para não bugar o patinho
    colisao.set_deferred("disabled", true) 
    
    var pos_inicial_garca = global_position
    animacao.play("voando")
    
    var tween_resgate = get_tree().create_tween()
    
    # ETAPA A: Mergulho
    var destino = alvo.global_position - Vector2(0, distancia_corpo_corpo)
    tween_resgate.tween_property(self, "global_position", destino, 0.8).set_trans(Tween.TRANS_SINE)
    tween_resgate.tween_callback(func(): animacao.play("pegando"))
    tween_resgate.tween_interval(0.2)
    
    # ETAPA B: Transporte
    tween_resgate.tween_callback(func(): animacao.play("voando"))
    tween_resgate.tween_property(alvo, "global_position", posicao_destino, 1.5)
    tween_resgate.parallel().tween_property(self, "global_position", posicao_destino + offset_bico_transporte, 1.5)
    
    # ETAPA C: Soltar e voltar
    tween_resgate.tween_callback(func():
        # Zera qualquer inércia que o patinho tenha acumulado no resgate
        alvo.velocity = Vector2.ZERO 
        alvo.set_physics_process(true) # Patinho volta à vida
        
        if alvo.get_parent() and "resgatando" in alvo.get_parent():
            alvo.get_parent().resgatando = false
        
        var tween_volta = get_tree().create_tween()
        tween_volta.tween_property(self, "global_position", pos_inicial_garca, 0.8)
        tween_volta.tween_callback(func():
            em_patrulha = true
            animacao.play("andando")
            
            # Liga a colisão da garça novamente ao voltar para a patrulha
            colisao.set_deferred("disabled", false) 
        )
    )
