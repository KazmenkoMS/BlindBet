class_name InventorySlotUI extends Button


var slot_data : SlotData : set = set_slot_data
var type : String #items/cards
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var card_slots: InventoryUI = $"../../../../Control2/PanelContainer/CardSlots"
@onready var inventory_slots: InventoryUI = $"../../../../Control/PanelContainer/InventorySlots"

var par : InventoryUI

func _ready() -> void:
	par = get_parent()
	
	if par.name == "CardSlots":
		type = "cards"
	elif par.name == "InventorySlots":
		type = "items"
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	#pressed.connect(item_pressed)
	await InventoryMenu.ready
	InventoryMenu.update_stats()


func _on_button_down() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		item_pressed()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		item_right_clicked()


func item_pressed() -> void:
	print(1)
	if slot_data != null:
		if type == "items" :
			if slot_data.item_data.type == "card":
				print("inv->cards")
				equip_card(slot_data.item_data)
			else:
				inventory_slots.data.use_item(get_index()) 
				inventory_slots.update_inventory()
		elif type == "cards":
			print("cards->inv")
			unequip_card(slot_data.item_data)
	pass


func unequip_card(card : ItemData) -> void:
	if InventoryMenu.items.add_item(slot_data.item_data):
		card.card_debuff()
		InventoryMenu.update_stats()
		InventoryMenu.cards.remove_item(get_index())
		card_slots.update_inventory()
		inventory_slots.update_inventory()
		InventoryMenu.update_item_description("")
	

func equip_card(card : ItemData) -> void:
	if InventoryMenu.cards.add_item(card):
		card.card_buff()
		InventoryMenu.update_stats()
		InventoryMenu.items.remove_item(get_index())
		inventory_slots.update_inventory()
		card_slots.update_inventory()
		InventoryMenu.update_item_description("")


func item_right_clicked() -> void:
	par.data.remove_item(get_index())
	par.update_inventory()

func _on_mouse_entered() -> void:
	pass

func _on_mouse_exited() -> void:
	pass
		
func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	if slot_data == null:
		# Очищаем отображение
		texture_rect.texture = null
		label.text = ""
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str( slot_data.quantity )


func item_focused() -> void:
	par.active_slot = par.get_children().find(self)
	if slot_data != null:
		if slot_data.item_data != null:
			InventoryMenu.update_item_description( slot_data.item_data.description )
	pass


func item_unfocused() -> void:
	InventoryMenu.update_item_description( "" )
	pass
