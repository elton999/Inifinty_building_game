package entities.actors;

import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public function new()
	{
		super();
		makeGraphic(10, 30, FlxColor.RED);
		setSize(10, 30);
	}

	public var stage:PlayState;

	public override function update(elapsed:Float)
	{
		if (visible && !this.stage.isChangingFloor)
		{
			FlxVelocity.moveTowardsObject(this, this.stage.Player, 40);
			velocity.set(velocity.x, 400);
			super.update(elapsed);
		}
	}
}
