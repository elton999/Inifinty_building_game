package entities.solids;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.math.Vector2;

class Elevator extends FlxSprite
{
	public function new(x:Float = 32, y:Float = 8)
	{
		super(x, y);
		makeGraphic(Std.int(x), Std.int(y), FlxColor.BLUE);
		setSize(x, y);
		this._isMoving = true;
	}

	public var paths:Array<Vector2> = new Array<Vector2>();
	public var goToPath:Int = 1;
	public var fromToPath:Int = 0;

	private var speed:Float = 40;

	public var stage:PlayState;

	public override function update(elapsed:Float)
	{
		if (!stage.isChangingFloor)
		{
			super.update(elapsed);
			this.move(elapsed);
		}
	}

	var _isMoving:Bool = false;

	public function move(elapsed:Float)
	{
		if (_isMoving)
		{
			FlxTween.linearPath(this, [FlxPoint.get(x, y), FlxPoint.get(paths[goToPath].x, paths[goToPath].y)], this.speed, false, {
				onComplete: backToOtherlevel,
				type: ONESHOT,
				startDelay: 2
			});
			_isMoving = false;
		}
	}

	private function backToOtherlevel(tween:FlxTween)
	{
		goToPath = goToPath == 1 ? 0 : 1;
		_isMoving = true;
	}
}
