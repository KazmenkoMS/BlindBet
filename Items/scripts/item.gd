extends Area2D

@export var item_data : ItemData 
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = item_data.texture
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.

func _on_body_entered(body: Node) -> void:
	var data : InventoryData = load("res://GUI/inventory/player_inventory.tres")
	data.add_item(item_data)
	queue_free()  # Удаляем предмет с карты
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
