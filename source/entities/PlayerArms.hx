package entities;

import entities.actors.Player;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class PlayerArms extends FlxSprite
{
	public var player:Player;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.arms__png, true, 64, 64);
		this.setAnimations();
	}

	public override function update(elapsed:Float)
	{
		// this.playAnimation();

		setPosition(player.x, player.y);
		offset = FlxPoint.get(player.offset.x, player.offset.y + 2);
		scale = player.scale;
		flipX = player.flipX;

		super.update(elapsed);
	}

	private function setAnimations()
	{
		animation.add("idle", [0, 1, 2, 3, 4], 10);
		animation.add("run", [9, 10, 11, 12, 13, 14, 15], 20);
		animation.add("die", [17, 18, 19, 20, 21], 5, false);
		animation.add("jump", [5]);
	}

	private function playAnimation()
	{
		if (this.player.velocity.x != 0 || !this.player.grounded)
			animation.play("jump");
		if (this.player.velocity.x == 0 && this.player.grounded)
			animation.play("idle");
	}
}
