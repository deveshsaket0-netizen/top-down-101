class_name Player
extends CharacterBody2D

# Variables
var cardinal_direction: Vector2 = Vector2.DOWN
const DIR4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction: Vector2 = Vector2.ZERO

var invulnerable = false
var hp : int = 6
var max_hp : int = 6

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: HitBox = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $statemachine


signal DirectionChanged(new_direction:Vector2)
signal player_damaged(hurt_box : HurtBox)
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.player = self
	state_machine.initialize(self)
	#hit_damaged.connect(_take_damage)
	update_hp(99)
	pass  # Replace with function body if needed.

# Called every frame.
# 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	direction = Vector2.ZERO
	if Input.is_action_pressed("Right"):
		direction.x += 1
	elif Input.is_action_pressed("Left"):
			direction.x -= 1
	if Input.is_action_pressed("Down"):
			direction.y += 1
	elif Input.is_action_pressed("Up"):
			direction.y -= 1
	if direction != Vector2.ZERO:
			direction = direction.normalized()


	# Normalize direction to prevent faster diagonal movement
	'''if direction.length() > 0:
		direction = direction.normalized()
		cardinal_direction = direction  # Update the last movement direction'''
	
	'''if SetState() == true || SetDirection() == true:
		UpdateAnimation()'''
	
	
func _physics_process(_delta):
	move_and_slide()

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int(round((direction + cardinal_direction * 0.1).angle()/TAU * DIR4.size()))
	var new_dir = DIR4[direction_id]
		
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
		
	


func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage( hurt_box:HurtBox) -> void:
	if invulnerable == true:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(99)
	
	pass
	


func update_hp(delta : int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	pass
	
func make_invulnerable( _duration : float = 1.0) -> void:
	invulnerable = true
	hitbox.monitoring = false
	await get_tree().create_timer( _duration ).timeout
	invulnerable = false
	hitbox.monitoring = true
	pass
	
