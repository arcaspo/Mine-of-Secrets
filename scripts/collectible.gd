extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_enum("Copper", "Diamond", "Gold", "Ruby", "Silver") var ore: String

func _ready() -> void:
	animated_sprite_2d.play(ore)
	animated_sprite_2d.frame = randi_range(0, 5)
