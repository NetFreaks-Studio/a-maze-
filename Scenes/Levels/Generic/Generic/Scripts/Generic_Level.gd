#res://Scenes/Levels/Generic/Generic/Scripts/Generic_Level.gd

extends Node2D

#Defines the rotation speed of the mase 
const rotationSpeed = 15;
const right = -1
const left = 1

const defaultGravityVector = Vector2(0,1);

var rotationPerPhysicsProcess = 0;

#Defines the number of times the turn button was pressed (Buffer)
var times = 0;
#Defines the number of times the labyrinth needs to rotate
var pendingRotations = 0;


	
func _physics_process(delta):
	_round_ball_to_the_axis();
	
	if Input.is_action_just_pressed("ui_left"):
		_rotate(right)
	elif Input.is_action_just_pressed("ui_right"):
		_rotate(left)
	
	_update_rotation_logic()

func _update_rotation_logic():
	if times > 0:
		pendingRotations = ceil(times/15.0);
		$Ball._rotate(rotationPerPhysicsProcess)
		times -= 1;
	else:
		rotationPerPhysicsProcess = 0;
		pendingRotations = 0


func _rotate(direction):
	if rotationPerPhysicsProcess*(direction) >= 0:
		times += rotationSpeed
	elif times > 0:
		times = pendingRotations * rotationSpeed - times
	rotationPerPhysicsProcess = direction*(PI/2)/rotationSpeed;
	
func _round_ball_to_the_axis():
	if pendingRotations == 0 and fmod($Ball.normal.angle(),PI/2) < 2:
		$Ball.normal.x = round($Ball.normal.x)
		$Ball.normal.y = round($Ball.normal.y)