#res://Scenes/Ball/Scripts/Ball.gd
extends KinematicBody2D

#constant by which the ball is accelerated down
const gravity = 10


#move_bounce_and_slide related varaibles
var mbs_collisions = []

#constant by which the balls velocity (motion.length()) is multiplied if the ball were to bounce straight up
const bounce_force = 0.225

#contants to make the ball rotation by friction look smooth
#---may-require-tweaks---
const friction = 0.03125*2
const friction_multiplier = 1

var motion = Vector2(0,0)
var normal = Vector2(0,-1)

var gravity_multiplier = 1
var rotation_force = 0

onready var sprite = $Sprite

func _process(delta):
	_rotate_sprite(delta)

func _physics_process(delta):
	_update_gravity()
	print(motion)
	print("mbs")
	motion = move_bounce_and_slide(motion, delta)
	print(motion)
	if mbs_collisions:
		for i in mbs_collisions:
			var col_motion = (i.travel + i.remainder)/delta
			var normal = i.normal
			_update_sprite_rotation(normal, col_motion, friction*friction_multiplier)
			motion = motion*lerp(bounce_force, 1, abs(col_motion.angle_to(-normal)/(PI/2)))
	else:
		rotation_force = rotation_force*0.99
	if motion == Vector2(0,0):
		rotation_force = 0
func _move_bounce_and_slide_aux(vel_rel, bounce_min):
	var col = move_and_collide(vel_rel)
	var result
	if col:
		mbs_collisions.append(col)
		
		var normal = col.normal
		var tangent = normal.tangent()
		
		var remainder = col.remainder
		
		var bounce = vel_rel.bounce(normal)
		
		var vertical_velocity_after_impact = normal.dot(bounce)
		var horizontal_velocity_after_impact = tangent.dot(bounce)
		
		var remainder_bounce = remainder.bounce(normal)
		if abs(vertical_velocity_after_impact) >= bounce_min:
			result = _move_bounce_and_slide_aux(bounce, bounce_min)
		elif abs(horizontal_velocity_after_impact) != 0:
			var slide = tangent*horizontal_velocity_after_impact
			var remainder_slide = tangent*tangent.dot(remainder_bounce)
			result = _move_bounce_and_slide_aux(slide, bounce_min)
		else:
			result = Vector2(0,0)
	else:
		 result = vel_rel
	return result.normalized()*vel_rel.length()

func move_bounce_and_slide(vel, delta):
	mbs_collisions = []
	var vel_rel = vel*delta
	var bounce_min = 100*delta
	return _move_bounce_and_slide_aux(vel_rel, bounce_min)/delta

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
func _rotate_sprite(delta):
	sprite.rotate(rotation_force*delta)

#updates the values by which the sprite will be rotated by (friction)
func _update_sprite_rotation(normal, motion, friction):
		rotation_force = -normal.tangent().dot(motion)*friction