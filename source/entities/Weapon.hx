package entities;

import entities.actors.Bullet;
import entities.actors.Player;
import flixel.FlxG;
import flixel.FlxSprite;

class Weapon
{
	public var stage:PlayState;
	public var character:Player;

	public function new(stage:PlayState)
	{
		this.stage = stage;
	}

	public function update(elapsed:Float)
	{
		this.input();
		this.fireCadence(elapsed);
	}

	var CFire:Bool = false;

	private function input():Void
	{
		this.CFire = FlxG.keys.anyPressed([X]);
	}

	private var timer:Float = 0;
	private var timeIntervalCadence:Float = 0.2;

	public function fireCadence(elapsed:Float):Void
	{
		this.timer = !this.CFire ? 0 : this.timer + elapsed;
		if (this.CFire && this.timer >= this.timeIntervalCadence)
			this.shoot();
	}

	public function shoot()
	{
		var bullet = this.createBullet();
		bullet.stage = this.stage;
		this.stage.add(bullet.light);
		this.stage.bullets.add(bullet);
		this.timer = 0;
		FlxG.camera.shake(0.003, 0.2);
	}

	private function createBullet():Bullet
	{
		var bullet:Bullet = new Bullet();
		bullet.flipX = character.flipX;
		bullet.speed = !character.right ? -bullet.speed : bullet.speed;
		var offsetX = !character.right ? -10 : 10;

		bullet.setPosition(this.character.getPosition().x + offsetX, this.character.getPosition().y + Std.random(5));
		this.stage.Player.smash();
		return bullet;
	}
}
