package entities;

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
		this.stage.bullets.add(this.createBullet());
		this.timer = 0;
		FlxG.camera.shake(0.005, 0.2);
	}

	private function createBullet():Bullet
	{
		var bullet:Bullet = new Bullet();
		bullet.speed = !character.right ? -bullet.speed : bullet.speed;

		bullet.setPosition(this.character.getPosition().x, this.character.getPosition().y + 5);

		return bullet;
	}
}
