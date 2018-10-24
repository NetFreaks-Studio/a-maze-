#res://Scenes/Ball/Scripts/Ball.gd

extends KinematicBody2D

const gravity = 10
const bounce_force = 0.225
const friction = 0.047
const friction_ratio = 75

# do not change ----------------
var sprite_rotation_speed = friction/friction_ratio
#               ----------------

var motion = Vector2(0,0)
var normal = Vector2(0,-1)

var gravity_multiplier = 1
var rotation_force = 0

func _physics_process(delta):
	rotation_degrees = round(rotation_degrees)
	$Sprite.rotate(rotation_force)
	if test_move(global_transform, delta*motion):
		motion -= normal*gravity*gravity_multiplier
		#motion -= motion*friction;
		var col = move_and_collide(motion)
		var aux_motion = motion.bounce(col.normal)
		motion = aux_motion*lerp(1, bounce_force, abs(motion.angle_to(aux_motion)/PI))
		if abs(normal.angle_to(motion)) != 0:
			rotation_force = (normal.angle_to(motion)/abs(normal.angle_to(motion)))*motion.length()*sprite_rotation_speed
		else:
			rotation_force = 0
	else:
		if get_slide_count()>0 or motion.length() == 0:
			motion -= motion*friction;
			#rotation_force = motion.length()*sprite_rotation_speed
			if abs(normal.angle_to(motion)) != 0:
				rotation_force = (normal.angle_to(motion)/abs(normal.angle_to(motion)))*motion.length()*sprite_rotation_speed
			else:
				rotation_force = 0
		motion -= normal*gravity*gravity_multiplier
		motion = move_and_slide(motion, normal)
	
func _rotate(rotation_factor):
	normal = normal.rotated(rotation_factor)
	motion = motion.rotated(rotation_factor)
	rotate(rotation_factor)