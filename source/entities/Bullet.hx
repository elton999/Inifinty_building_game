package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public function new(x:Float = 10, y:Float = 10)
	{
		super(x, y);
		makeGraphic(Std.int(x), Std.int(y), FlxColor.BLUE);
		setSize(x, y);
	}

	public var speed:Float = 350;
	public var isFromEnemy:Bool = false;

	public override function update(elapsed:Float):Void
	{
		velocity.set(speed, 0);
		super.update(elapsed);
	}
}
