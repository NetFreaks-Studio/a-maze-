#res://Scenes/Menus/Pause/Scripts/Resume.gd
extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.connect("pressed", self, "_on_Resume_pressed")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Resume_pressed():
	self.get_parent().get_parent().get_parent().hide()
	get_tree().paused = false
	