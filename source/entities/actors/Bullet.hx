package entities.actors;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var light:Light;
	public var stage:PlayState;

	public function new(x:Float = 10, y:Float = 5)
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

	public function destroyBullet()
	{
		var explosionEFX = new FlxSprite();
		explosionEFX.setPosition(x - 16, y - 16);
		explosionEFX.setSize(32, 32);
		explosionEFX.loadGraphic(AssetPaths.bullet_explosions__png, true, 32, 32);
		explosionEFX.animation.add("explosion", [0, 1, 2, 3, 4], 60, false);
		explosionEFX.animation.play("explosion", true);
		explosionEFX.animation.finishCallback = function(_)
		{
			explosionEFX.exists = false;
		}
		this.stage.add(explosionEFX);
		exists = false;
	}
}
