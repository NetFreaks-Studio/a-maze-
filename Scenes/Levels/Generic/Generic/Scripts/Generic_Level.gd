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

class foo:
	var hel = 0
	func _stfu():
		print("hi")
func _ready():
	var a = Vector2(1,0)
	a.rotated(PI)
	print(a)	
	
	
func _physics_process(delta):
	$Camera.position = $Ball.position;
	
	#print($Ball.motion)
	#print($Ball.normal)
	
	#rotates the world based on the variables set by the _rotate_* methods
	if times != 0:
		$Camera.rotate(rotationPerPhysicsProcess);
		$Ball.normal = $Ball.normal.rotated(rotationPerPhysicsProcess);
		times -= 1;
		pendingRotations = ceil(times/rotationSpeed);
	else:
		rotationPerPhysicsProcess = 0;
		
	#Updates gravity's direction as the world rotates

	
	
	

func _input(event):
	if Input.is_action_just_pressed("ui_left"):
		_rotate_right()
	if Input.is_action_just_pressed("ui_right"):
		_rotate_left()




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