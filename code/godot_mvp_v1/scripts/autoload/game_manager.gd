extends Node

signal player_died
signal enemy_killed(enemy: Node)
signal game_won
signal return_to_menu_requested
signal score_changed(new_score: int)

var score: int = 0
var is_game_over: bool = false
var is_won: bool = false

func reset_game() -> void:
	score = 0
	is_game_over = false
	is_won = false
	get_tree().paused = false

func on_player_died() -> void:
	if is_game_over or is_won:
		return
	is_game_over = true
	player_died.emit()

func on_enemy_killed(enemy: Node) -> void:
	add_score(1)
	enemy_killed.emit(enemy)

func boss_killed() -> void:
	if is_game_over or is_won:
		return
	add_score(5)
	is_won = true
	game_won.emit()

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func request_return_to_menu() -> void:
	reset_game()
	return_to_menu_requested.emit()
