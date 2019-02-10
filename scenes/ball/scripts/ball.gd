#res://Scenes/Ball/Scripts/Ball.gd
extends KinematicBody2D

#constant by which the ball is accelerated down
const gravity = 10


#move_bounce_and_slide related varaibles
var mbs_collisions = []

#constant by which the balls velocity (motion.length()) is multiplied if it were to bounce straight up
const bounce_force = 0.225

#contants to make the ball rotation by friction look smooth
#---may-require-tweaks---
const friction = 0.0415
const friction_ratio = 75

#-do-not-change-----------------
var sprite_rotation_speed = friction/friction_ratio
#-------------------------------

var motion = Vector2(0,0)
var normal = Vector2(0,-1)

var gravity_multiplier = 1
var rotation_force = 0

#processes bounces, sliding and free falling
func _physics_process(delta):
	_update_gravity()
	move_bounce_and_slide(motion, delta)
	for i in mbs_collisions:
		var aux_motion = motion.bounce(i.normal)
		motion = aux_motion*lerp(1, bounce_force, abs(motion.angle_to(aux_motion)/PI))
		_update_sprite_rotation()
	_rotate_sprite()

func _move_bounce_and_slide_aux(vel_rel, slide_min, remainder):
	var col = move_and_collide(vel_rel)
	if col:
		mbs_collisions.append(col)
		var normal = col.normal
		var bounce = vel_rel.bounce(normal)
		var distance = normal.dot(bounce)
		if distance >= slide_min:
			_move_bounce_and_slide_aux(bounce, slide_min, remainder)
			return bounce
		elif distance:
			var tangent = normal.tangent()
			var slide = tangent.normalized()*tangent.dot(vel_rel)
			_move_bounce_and_slide_aux(slide, slide_min, remainder)
			return slide
	return vel_rel

func move_bounce_and_slide(vel, delta):
	mbs_collisions = []
	var vel_rel = vel*delta
	var slide_min = 100*delta
	return _move_bounce_and_slide_aux(vel_rel, slide_min, vel_rel)/delta

#rotates the ball and all its physics atributes. 
#Desired effect for the end user: map is rotated, the ball keeps being affected by the gravity (falling down), as per usual
func _rotate(rotation_factor):
	normal = normal.rotated(rotation_factor)
	motion = motion.rotated(rotation_factor)
	rotate(rotation_factor)
	
#welp, updates the gravity c:
func _update_gravity():
	motion -= normal*gravity*gravity_multiplier

#rotates the sprite based on friction
func _rotate_sprite():
	$Sprite.rotate(rotation_force)

#updates the values by which the sprite will be rotated by (friction)
func _update_sprite_rotation():
	if abs(normal.angle_to(motion)) != 0:
		rotation_force = (normal.angle_to(motion)/abs(normal.angle_to(motion)))*(normal.rotated(PI/2).abs()*motion).length()*sprite_rotation_speed		
		
func test(vec):
	move_and_collide(vec)