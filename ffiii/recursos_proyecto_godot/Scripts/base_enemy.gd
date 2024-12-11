extends Resource

#this acts as base for every enemy i decide to put in the game

@export var name: String = "Enemy"
@export var texture: Texture = null
@export var level: int = 1
@export var health: int = 30*level
@export var damage: int = 20
