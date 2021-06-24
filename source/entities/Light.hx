package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

class Light extends FlxSprite
{
	public function new()
	{
		super();
		loadGraphic(AssetPaths.radial__png);
		scale = FlxPoint.get(0.3, 0.3);
		blend = DIFFERENCE;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
