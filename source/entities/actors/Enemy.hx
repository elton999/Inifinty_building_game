package entities.actors;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxRange;
import flixel.util.helpers.FlxRangeBounds;

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
			FlxVelocity.moveTowardsObject(this, this.stage.Player, 20);
			velocity.set(velocity.x, 200);
			super.update(elapsed);
		}
	}

	public function bleed(pointX:Float = 0, pointY:Float = 0)
	{
		var emitter = new FlxEmitter(100, 100);
		emitter.setPosition(pointX, pointY);

		for (i in 0...30)
		{
			var p = new FlxParticle();
			var sizep = Std.random(4) + 1;
			p.makeGraphic(sizep, sizep, FlxColor.RED);
			p.setSize(sizep, sizep);
			p.exists = false;
			p.angularAcceleration = 90;
			emitter.add(p);
		}

		emitter.allowCollisions = FlxObject.ANY;
		emitter.speed.start.max = 50;
		this.stage.add(emitter);
		this.stage.emitters.add(emitter);
		emitter.start(true, 5, 20);

		FlxG.camera.shake(0.01, 0.2);
		var color = FlxColor.WHITE;
		color.alpha = 100;
		FlxG.camera.flash(color, 0.2, true);
	}
}
