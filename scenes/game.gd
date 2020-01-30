extends Node

const Globals = preload("res://scripts/globals.gd")
const Players = Globals.Players

var GameResult = preload("res://scenes/game_result.tscn")
var game_result = GameResult.instance()

var MinMaxAlgo = preload("res://scripts/minMaxAlgo.gd")
var RandomAlgo = preload("res://scripts/minMaxAlgo.gd")
var currentAlgo = RandomAlgo.new()

var humanTurn = false
var rng = RandomNumberGenerator.new()

var player_name
var cpu_name

var currentPlay = 0
var currentPlayer = Players.X

func _ready():
	print("going ready...")
	player_name = get_node("UI/player_name")
	cpu_name = get_node("UI/cpu_name")
	initSignals()
	var cases = get_node("Board/cases").get_children()
	for case in cases:
		case.connect("pressed", self, "_on_case_pressed", [case])
	newGame()

func initSignals() -> void:
	get_node("UI/btn_menu").connect("pressed", self, "_on_btn_menu_pressed")

func newGame() -> void:
	rng.randomize()
	var rdmn = rng.randi_range(0, 1)
	humanTurn = (rdmn == 1)
	currentPlay = 0
	currentPlayer = Players.X
	enabledBoard()
	if humanTurn == false:
		cpuPlay()

func updatePlayersNameIndicator() -> void:
	if humanTurn == true:
		player_name.showSprite()
		cpu_name.hideSprite()
	else:
		player_name.hideSprite()
		cpu_name.showSprite()

func enabledBoard() -> void:
	updatePlayersNameIndicator()
	var cases = get_node("Board/cases").get_children()
	for case in cases:
		case.reset()

func _on_case_pressed(case) -> void:
	if humanTurn == true:
		print(case.label + ": pressed")
		if currentPlay < 9:
			playMove(case)
			humanTurn = false
			updatePlayersNameIndicator()
			cpuPlay()
	
func cpuPlay() -> void:
	if currentPlay < 9:
		yield(get_tree().create_timer(1.0), "timeout")
		var cases = get_node("Board/cases").get_children()
		var cases_null = []
		for case in cases:
			if case.player == null:
				cases_null.append(case)
		var caseCpu = currentAlgo.findBestMove(cases_null)
		playMove(caseCpu)
		humanTurn = true
		updatePlayersNameIndicator()
	
func playMove(case) -> void:
	if case.player == null:
		case.setPlayer(currentPlayer)
		if currentPlayer == Players.X:
			currentPlayer = Players.O
		else:
			currentPlayer = Players.X
		currentPlay += 1
	gameStatus()

func gameStatus() -> void:
	var winner = getWinner()
	if winner != null:
		var winner_name = ("Humain" if humanTurn else "CPU")
		if winner == Players.X:
			currentPlay = 9
			game_result.get_node("message").text = "Victoire de " + winner_name + " avec les X !"
		elif winner == Players.O:
			currentPlay = 9
			game_result.get_node("message").text = "Victoire de " + winner_name + " avec les O !"
		elif currentPlay > 8:
			game_result.get_node("message").text = "Match nul !"
			
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().get_root().add_child(game_result)
	
func getWinner():
	var cases = get_node("Board/cases")
	# horizontales
	if ( cases.get_node("case01").player == cases.get_node("case02").player
	&& cases.get_node("case02").player == cases.get_node("case03").player ):
		return cases.get_node("case01").player
	if ( cases.get_node("case04").player == cases.get_node("case05").player
	&& cases.get_node("case05").player == cases.get_node("case06").player ):
		return cases.get_node("case04").player
	if ( cases.get_node("case07").player == cases.get_node("case08").player
	&& cases.get_node("case08").player == cases.get_node("case09").player ):
		return cases.get_node("case07").player
		
	# verticales
	if ( cases.get_node("case01").player == cases.get_node("case04").player
	&& cases.get_node("case04").player == cases.get_node("case07").player ):
		return cases.get_node("case01").player
	if ( cases.get_node("case02").player == cases.get_node("case05").player
	&& cases.get_node("case05").player == cases.get_node("case08").player ):
		return cases.get_node("case02").player
	if ( cases.get_node("case03").player == cases.get_node("case06").player
	&& cases.get_node("case06").player == cases.get_node("case09").player ):
		return cases.get_node("case03").player
		
	# diagonales
	if ( cases.get_node("case01").player == cases.get_node("case05").player
	&& cases.get_node("case05").player == cases.get_node("case09").player ):
		return cases.get_node("case01").player
	if ( cases.get_node("case03").player == cases.get_node("case05").player
	&& cases.get_node("case05").player == cases.get_node("case07").player ):
		return cases.get_node("case03").player
		
	return null

func _on_btn_menu_pressed() -> void:
	queue_free()
	get_tree().change_scene("res://scenes/menu.tscn")