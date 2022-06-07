extends Area2D

var screensize

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
###
# Configures the coin animation and the pickup animations tweens
#
###
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
	$Timer.wait_time = rand_range(3,8)
	$Timer.start()
	pass # Replace with function body.


###
# Routine to start the coin pickup animation
#
###
func pickup():
	monitoring = false
	$Tween.start()	

###
# Routine to delete the coin object when animation completes
# It is connected to the tween_completed signal from the Tween Object
###
func _on_Tween_tween_completed(object, key):
	queue_free()
	pass # Replace with function body.

###
# Routine to animate the powerup graphics
# It is connected to the Timer timeout signal/event (component)
###
func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
	pass # Replace with function body.

###
# Routine to prevent the powerup to be spawned on top of obstacles
# It is connecet to the area_entered signal from the PowerUp (Scene) Area2D object
###
func _on_Coin_area_entered(area):
	if area.is_in_group("obstacles"):
		# Reposicione a moeda se ela coincidir com um obstáculo
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
	pass # Replace with function body.
