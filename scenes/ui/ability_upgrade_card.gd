extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var level_label: Label = $%MaxLevelLabel


func _ready():
	gui_input.connect(on_gui_input)
	
func get_max_level_label(upgrade: AbilityUpgrade):
	var current_level = upgrade.level


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	if(event.is_action_pressed("left_click")):
		selected.emit()
