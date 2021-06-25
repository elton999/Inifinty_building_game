package entities.actors;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var light:Light;

	public function new(x:Float = 5, y:Float = 5)
	{
		super(x, y);
		// makeGraphic(Std.int(x), Std.int(y), FlxColor.BLUE);
		loadGraphic(AssetPaths.fire__png, true, Std.int(x), Std.int(y));
		setSize(x, y);
		setGraphicSize(Std.int(x), Std.int(y));
		light = new Light();
		light.scale = FlxPoint.get(0.2, 0.2);
		light.color = FlxColor.YELLOW;
		light.alpha = 0.8;
	}

	public var speed:Float = 350;
	public var isFromEnemy:Bool = false;

	public override function update(elapsed:Float):Void
	{
		velocity.set(speed, 0);
		light.setPosition(x - 200, y - 200);
		light.exists = this.exists;
		super.update(elapsed);
	}
}
