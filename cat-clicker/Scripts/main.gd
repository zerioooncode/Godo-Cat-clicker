extends Node2D # <--- для пометок

# Переменные v

@onready var counter: Label = $Counter
@onready var shop_pnl: Panel = $Shop_pnl
@onready var upgrade_lbl: Label = $Upgrade_btn/Upgrade_lbl
@onready var quit_btn: Button = $Quit_btn
@onready var stats_lbl: Label = $Stats_lbl
@onready var hamster_lbl: Label = $Shop_pnl/Hamster_auto_btn/Hamster_lbl
@onready var auto_upgrade_lvl_lbl: Label = $Shop_pnl/Hamster_auto_btn/Auto_upgrade_lvl_lbl
@onready var timer: Timer = $Timer
@onready var cat_click_sound: AudioStreamPlayer = $CatClickSound
@onready var button_click_sound: AudioStreamPlayer = $ButtonClickSound


var coins = 0
var bonus = 1
var upgrade_cost = 15

var auto_coins = 0         # Сколько монет дает хомяк за 1 тик таймера
var auto_upgrade_cost = 100
var auto_upgrade_lvl = 0

# Переменные ^

func _ready() -> void:
	shop_pnl.visible = false
	timer.wait_time = 1.0   # Должно быть 1.0
	timer.start()

func _process(delta: float) -> void:
	# Обновление UI
	counter.text = str(int(coins)) + "$"
	upgrade_lbl.text = "Upgrade: " + str(int(upgrade_cost)) + "$\n+1$/click"
	
	# Логика отображения хомяка
	if auto_upgrade_lvl < 10:
		hamster_lbl.text = "Hamster: " + str(int(auto_upgrade_cost)) + "$\n+1$/sec"
	else:
		hamster_lbl.text = "Hamster: " + str(int(auto_upgrade_cost)) + "$\n+3$/0.5 sec"
		
	stats_lbl.text = "Stats:\nClick power: " + str(bonus) + "\nAuto click power: " + str(auto_coins)
	auto_upgrade_lvl_lbl.text = "Hamster lvl: " + str(auto_upgrade_lvl)

# Интерфейс v

func _on_shop_btn_pressed() -> void:
	shop_pnl.visible = true

func _on_store_exit_btn_pressed() -> void:
	shop_pnl.visible = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

# Интерфейс ^

func _on_cat_btn_pressed() -> void:
	coins += 1 * bonus
	cat_click_sound.play()

func _on_upgrade_btn_pressed() -> void:
	if coins >= upgrade_cost:
		coins -= upgrade_cost
		bonus += 1
		upgrade_cost = int(upgrade_cost * 1.1)

func _on_hamster_auto_btn_pressed() -> void:
	if coins >= auto_upgrade_cost:
		coins -= auto_upgrade_cost
		auto_upgrade_lvl += 1
		
		# Прокачка
		if auto_upgrade_lvl <= 10:
			auto_coins += 1 
		else:
			auto_coins += 3
			
			# Сокращаю время работы таймера при прокачке до 11 уровня
		if auto_upgrade_lvl == 11:
			timer.wait_time = 0.5 
			
		auto_upgrade_cost = int(auto_upgrade_cost * 1.1)


func _on_timer_timeout() -> void:
	coins += auto_coins
