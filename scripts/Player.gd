extends KinematicBody2D

onready var sprite = self.get_node("Sprite")
onready var animPlayer = self.get_node("AnimationPlayer")

export var speed = 50
export var friction = 0.5
export var acceleration = 0.2
export var jump_power = 100
var velocity = Vector2.ZERO


func _input(_event):
	if Input.is_action_pressed("attack"):
		animPlayer.play("SideSlash")


func _physics_process(_delta):
	var input_velocity = Vector2.ZERO
	# Check input for "desired" velocity
	if Input.is_action_pressed("ui_right"):
		sprite.set_flip_h(true)
		input_velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		sprite.set_flip_h(false)
		input_velocity.x -= 1
	input_velocity = input_velocity.normalized() * speed
	
	if Input.is_action_pressed("jump"):
		input_velocity.y = -jump_power
	
	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)


func _on_AnimationPlayer_animation_finished(_anim_name):
	animPlayer.play("WalkLeft")
