extends EnemyBase

func die() -> void:
	GameManager.boss_killed()
	queue_free()
