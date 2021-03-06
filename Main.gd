extends Node

### Configurable properties (exposed to the Godot Inspector UI)
export (PackedScene) var Coin
export (PackedScene) var Powerup
export (PackedScene) var Cactus
export (int) var playtime

### Internal Game Properties
var level
var score
var time_left
var screensize
var playing = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	pass # Replace with function body.

###
# Routine to reset the properties and start a new game
# It is connected to the start_game signal from HUD, implemented in the HUD scene file.
#
###
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$PowerUpTimer.wait_time = rand_range(5,10)
	$PowerUpTimer.start()
	spawn_coins()
	spawn_obstacles()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_coins():
	$LevelSound.play()
	for i in range(4+level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
# Called every frame. 'delta' is the elapsed time since the previous frame.

func spawn_obstacles():
	for i in range(2):
		var c = Cactus.instance()
		$CactusContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

func reset_obstacles():
	for child in $CactusContainer.get_children():
		var pos = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
		child.position = pos

func remove_obstacles():
	for child in $CactusContainer.get_children():
		child.queue_free()

func _process(delta):
	if playing and $CoinContainer.get_child_count()==0:
		level += 1
		time_left +=5
		spawn_coins()
		reset_obstacles()
		$PowerUpTimer.wait_time = rand_range(5,10)
		$PowerUpTimer.start()

###
# Routine to stop the game to a game over state
# It is connected to the timeout event/signal of the GameTimer (proper object)
#
###
func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left<=0:
		game_over()
	pass # Replace with function body.

###
# player hurt event handle to finish the game when player loses
# It is connected to the hurt signal/event of Player (Scene)
###
func _on_Player_hurt():
	game_over()
	pass # Replace with function body.

###
# player Pickup event handle to update player score or game timer
# It is connected to the pickup signal/event of Player (Scene)
###
func _on_Player_pickup(type):
	match type:
		"coin":
			score+=1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			time_left += 5
			$PowerUpSound.play()
			$HUD.update_timer(time_left)
	pass # Replace with function body.

func game_over():
	playing = false
	$EndSound.play()
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	remove_obstacles()
	$HUD.show_game_over()
	$Player.die()

###
# Powerup Timeout routine to add a powerup in the scene when the Timer triggers
# It is connected to the timeout signal/event of the PowerUpTimer
#
###

func _on_PowerUpTimer_timeout():
	var p = Powerup.instance()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(rand_range(0, screensize.x),
						 rand_range(0,screensize.y))
	pass # Replace with function body.
	
