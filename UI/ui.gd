extends CanvasLayer

@onready var too_close_label: Label = $TooCloseLabel
@onready var monster_icon: TextureRect = $SpawnUI/MonsterIcon
@onready var cooldown_overlay: TextureProgressBar = $SpawnUI/CooldownOverlay
@onready var cooldown_label: Label = $SpawnUI/CooldownLabel

@export var scene: Node2D
@export var spawn_timer: Timer
@export var monster_textures: Dictionary[String, Texture2D] = {}

var is_on_cooldown = false

func _ready() -> void:
	too_close_label.visible = false
	scene.spawned_too_close.connect(_on_spawn_too_close)
	scene.spawn_on_cooldown.connect(_on_spawn_on_cooldown)
	
	cooldown_overlay.max_value = 100
	cooldown_overlay.value = 0
	cooldown_overlay.fill_mode = TextureProgressBar.FILL_COUNTER_CLOCKWISE
	cooldown_overlay.radial_initial_angle = 90.0
	cooldown_overlay.visible = false
	
	cooldown_label.visible = false
	
	if spawn_timer:
		spawn_timer.timeout.connect(_on_cooldown_finished)


func _process(_delta):
	if is_on_cooldown and spawn_timer:
		var time_left = spawn_timer.time_left
		var total_time = spawn_timer.wait_time
		var progress_percent = (time_left / total_time) * 100
		
		cooldown_overlay.value = progress_percent
		cooldown_label.text = "%.1f" % time_left


func _on_spawn_too_close():
	if too_close_label.visible:
		return
	
	too_close_label.visible = true
	await get_tree().create_timer(2.0).timeout
	too_close_label.visible = false


func _on_spawn_on_cooldown():
	var tween = create_tween()
	tween.tween_property(monster_icon, "rotation", deg_to_rad(10), 0.05)
	tween.tween_property(monster_icon, "rotation", deg_to_rad(-10), 0.05)
	tween.tween_property(monster_icon, "rotation", 0, 0.05)


func start_cooldown():
	is_on_cooldown = true
	cooldown_overlay.visible = true
	cooldown_label.visible = true
	monster_icon.modulate = Color(0.5, 0.5, 0.5)


func _on_cooldown_finished():
	is_on_cooldown = false
	cooldown_overlay.visible = false
	cooldown_label.visible = false
	monster_icon.modulate = Color.WHITE


func update_monster_icon(monster_type: String):
	if monster_textures.has(monster_type):
		monster_icon.texture = monster_textures[monster_type]
