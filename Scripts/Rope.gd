extends Area2D

#to do:
#better physics for connects from (have object connected to be effected by velocity, and other changes when needed)

var velocity = Vector2(0,0)

#direction from point to connects_to
var direction_to
#distance from point to connects_to
var distance_to

##export variables
##important stuff
#what this point connects to
@export var connects_to: Node

#what this point connects from
@export var connects_from: Node

#the max distance between this point and its connect_to before it starts pulling
@export var length: float

#How much force is exerted by the rope when streched
@export var stiffness: float

##less important stuff
#if the point should be effected by gravity
@export var use_gravity: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()


func _physics_process(delta):
	#default physics
	velocity -= (velocity / 3) * delta
	position += velocity * delta
	if use_gravity == true:
		velocity.y += 150 * delta
		
	#direction and distance calculaton
	if connects_to != null:
		direction_to = (connects_to.position - position).normalized()
		distance_to = global_position.distance_to(connects_to.global_position)
	
	#move connects_to
	if connects_to != null && distance_to > length:
		connects_to.velocity -= direction_to * (stiffness * (pow((distance_to - length), 0.7)))
		velocity += direction_to * (stiffness * (pow((distance_to - length), 0.7)))
	
	#attaches point to connects_from
	if connects_from != null:
		position = connects_from.position

func _draw():
	if connects_to != null:
		draw_line(Vector2(), direction_to * distance_to, Color.GREEN, 16)
