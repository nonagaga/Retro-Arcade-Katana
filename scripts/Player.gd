extends KinematicBody2D

onready var sprite = self.get_node("Sprite")
onready var animPlayer = self.get_node("AnimationPlayer")

export var gravity = 10
export var speed = 50
export var jump_power = 160
var velocity = Vector2.ZERO

var is_SideSlash_next = true

func _input(_event):
	if Input.is_action_pressed("attack"):
		if animPlayer.get_current_animation() == "WalkLeft":
			if is_SideSlash_next:
				animPlayer.play("SideSlash")
				is_SideSlash_next = false
			else:
				animPlayer.play("TopSlash")
				is_SideSlash_next = true


func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	
	if input_vector.x > 0:
		sprite.set_flip_h(true)
		
	if input_vector.x < 0:
		sprite.set_flip_h(false)
	
	input_vector = input_vector.normalized()
	velocity.x = input_vector.x * speed
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_power


func _on_AnimationPlayer_animation_finished(_anim_name):
	animPlayer.play("WalkLeft")
