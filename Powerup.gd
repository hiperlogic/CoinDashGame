extends Area2D

var screensize

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(
		$AnimatedSprite, 'scale',
		$AnimatedSprite.scale,
		$AnimatedSprite.scale * 3, 0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
		Color(1,1,1,1),
		Color(1,1,1,0), 0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	$Timer.wait_time = rand_range(1,3)
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pickup():
	monitoring = false
	$Tween.start()
	$Lifetime.start()
	

func _on_Lifetime_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
	pass # Replace with function body.


func _on_Powerup_area_entered(area):
	if area.is_in_group("obstacles"):
		# Reposicione a moeda se ela coincidir com um obstáculo
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
		pass # Replace with function body.
