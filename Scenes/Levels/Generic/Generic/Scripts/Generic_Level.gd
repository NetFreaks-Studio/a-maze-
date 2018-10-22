#res://Scenes/Levels/Generic/Generic/Scripts/Generic_Level.gd

extends Node2D

#Defines the rotation speed of the mase 
const rotationSpeed = 15;

const defaultGravityVector = Vector2(0,1);

var rotationPerPhysicsProcess = 0;

#Defines the number of times the turn button was pressed (Buffer)
var times = 0;
#Defines the number of times the labyrinth needs to rotate
var pendingRotations = 0;

func _physics_process(delta):
	$Camera.position = $Ball.position;
	print($Ball.linear_velocity)
	
	#rotates the world based on the variables set by the _rotate_* methods
	if times != 0:
		$Camera.rotate(rotationPerPhysicsProcess);
		times -= 1;
		pendingRotations = ceil(times/rotationSpeed);
	else:
		rotationPerPhysicsProcess = 0;
		
	#Updates gravity's direction as the world rotates
	Physics2DServer.area_set_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, defaultGravityVector.rotated($Camera.rotation))

func _input(event):
	if Input.is_action_just_pressed("ui_right"):
		_rotate_right()




#makes the world rotate left
#is called by LeftArrow signal: Just_Pressed 
func _rotate_left():
	if rotationPerPhysicsProcess >= 0:
		times += rotationSpeed;
	else:
		times = pendingRotations * rotationSpeed - times;
	rotationPerPhysicsProcess = (PI/2)/rotationSpeed;

#makes the world rotate right
#is called by RightArrow singla: Just_Pressed
func _rotate_right():
	if rotationPerPhysicsProcess <= 0:
		times += 15;
	else:
		times = pendingRotations * rotationSpeed - times;
	rotationPerPhysicsProcess = -(PI/2)/rotationSpeed;