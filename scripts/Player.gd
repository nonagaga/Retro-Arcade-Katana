extends KinematicBody2D

onready var sprite = self.get_node("Sprite")
onready var anim_player = self.get_node("AnimationPlayer")

export (int) var gravity = 10
export (int) var speed = 70
export (int) var jump_power = 160
export (int) var max_jump_count = 2
var current_jump_count = 1

var velocity = Vector2.ZERO

var is_SideSlash_next = true

func _input(_event):
	if Input.is_action_pressed("attack"):
		if anim_player.get_current_animation() == "WalkLeft":
			if is_SideSlash_next:
				anim_player.play("SideSlash")
				is_SideSlash_next = false
			else:
				anim_player.play("TopSlash")
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
	
	if is_on_floor():
		current_jump_count = 0
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_power
			current_jump_count = 0
		elif (current_jump_count + 1 < max_jump_count):
			velocity.y = -jump_power
			current_jump_count = current_jump_count + 1

func _on_AnimationPlayer_animation_finished(_anim_name):
	anim_player.play("WalkLeft")
