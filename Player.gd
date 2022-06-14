extends Area2D

signal pickup
signal hurt

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)

# Direction of the touch from the player
var target = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)
	

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x-=1
	if Input.is_action_pressed("ui_right"):
		velocity.x+=1
	if Input.is_action_pressed("ui_up"):
		velocity.y-=1
	if Input.is_action_pressed("ui_down"):
		velocity.y+=1
	if velocity.length()>0:
		velocity = velocity.normalized()*speed
		

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		print("Clicou")
		target = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Only for controllers or keyboard
	#get_input()
	velocity = (target - position).normalized()*speed
	if (target - position).length() > 5:
		position += velocity*delta
	else:
		velocity = Vector2()
	
	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"
	#position+=velocity*delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.length()>0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x<0
	else:
		$AnimatedSprite.animation = "idle"
	pass


func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()
		
	pass # Replace with function body.
