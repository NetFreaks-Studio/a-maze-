#res://Scenes/Ball/Scripts/Ball.gd

extends KinematicBody2D

const gravity = 10
const bounce_force = 0.225
const friction = 0.047
const friction_ratio = 75
const colliding = false

# do not change ----------------
var sprite_rotation_speed = friction/friction_ratio
#               ----------------

var motion = Vector2(0,0)
var normal = Vector2(0,-1)

var gravity_multiplier = 1
var rotation_force = 0

func _physics_process(delta):
	#rotate(rotation_force)

	motion -= normal*10
	if test_move(global_transform, delta*motion):
		if colliding == false:
			var colliding = true;
			var aux_motion = motion;
			var col = move_and_collide(motion)	
			motion = motion.bounce(col.normal).normalized()*lerp(bounce_force*motion.length(), motion.length(), motion.angle_to(aux_motion)/PI)
			#if motion.length() <= 3:
				#motion = Vector2(0,0)
	else:
			motion = move_and_slide(motion, normal)
		
func _get_normal():
	return normal

func _set_normal(normal1):
	normal = normal1;