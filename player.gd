extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var win = false
var respawning = false

func do_win():
	win = true
	velocity.x = 0
	velocity.y = 0
	get_parent().get_node("Victory").visible = true

func do_die():
	respawning = true
	velocity.x = 0
	position = Vector2(1, 1)

func do_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
		respawning = false

func do_input():
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: = Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func check_collision():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if not is_instance_valid(collider):
			continue
		if collider.name == "DeathTiles":
			do_die()
		if collider.name == "Goal":
			do_win()


func _physics_process(delta: float) -> void :
	if win:
		return

	do_gravity(delta)
	check_collision()

	if not respawning:
		do_input()

	move_and_slide()
