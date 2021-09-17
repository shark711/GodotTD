extends PathFollow2D

var speed = 150
var hp = 1000

onready var healh_bar = get_node("HealthBar")
onready var impact_area = get_node("Impact")
var bullet_impact = preload("res://Scenes/SupportScenes/BulletImpact.tscn")

func _ready():
	healh_bar.max_value = hp
	healh_bar.value = hp
	healh_bar.set_as_toplevel(true)

func _physics_process(delta):
	move(delta)


func move(delta):
	if hp > 0:
		set_offset(get_offset() + speed * delta)
	healh_bar.set_position(position - Vector2(30, 30))


func on_hit(damage):
	impact()
	hp -= damage
	healh_bar.value = hp
	if hp <= 0:
		on_destroy()


func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = bullet_impact.instance()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	get_node("KinematicBody2D").queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()
