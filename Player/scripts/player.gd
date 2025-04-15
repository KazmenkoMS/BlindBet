class_name Player extends CharacterBody2D

signal direction_changed( new_direction: Vector2 )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false



@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
var PlayerStats : PlayerStats 



# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats = load("res://PlayerResources/player_stats.tres")
	PlayerManager.player = self
	state_machine.Initialize(self)
	PlayerStats.change_hp(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass


func _physics_process( _delta ):
	move_and_slide()



func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true



func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass

func _on_body_entered(body: Node) -> void:
	print("battle")  # Или body.is_in_group("player")
		
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

 # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if (area.name == "Enemy"):
		start_battle()
		
func start_battle() -> void:
	# Загружаем сцену боя
	LevelManager.load_new_level("res://Levels/Area01/battle.tscn","LevelTransition",Vector2(40,20))
	
