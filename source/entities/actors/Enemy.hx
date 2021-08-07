package entities.actors;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public function new()
	{
		super();
		// makeGraphic(10, 30, FlxColor.RED);
		loadGraphic(AssetPaths.enemy__png, true, 64, 64);
		offset = FlxPoint.get(28, 18);
		setSize(10, 30);
		this.setAnimation();
		this.animation.play("idle");
	}

	public var stage:PlayState;

	public function canAttack():Bool
	{
		return this.stage.Player.y - this.getPosition().y < 50;
	}

	public override function update(elapsed:Float)
	{
		if (this.stage.canUpdate() && canAttack())
		{
			FlxVelocity.moveTowardsObject(this, this.stage.Player, 20);
			velocity.set(velocity.x, 200);

			offset.y = ((30 - 30 * scale.y) / 2) + 18;
		}

		if (velocity.x == 0)
			this.animation.play("idle");
		else
			this.animation.play("walk");

		this.flipX = velocity.x < 0;

		super.update(elapsed);
		FlxG.collide(this, this.stage.floor);
	}

	public function demage(pointX:Float = 0, pointY:Float = 0)
	{
		FlxTween.tween(this, {"scale.x": 0.8, "scale.y": 1.2}, 0.1, {
			onComplete: function(_)
			{
				this.exists = false;
				this.bleed(pointX, pointY);
			},
			type: ONESHOT
		});
	}

	public function bleed(pointX:Float = 0, pointY:Float = 0)
	{
		this.color = FlxColor.RED;
		var emitter = new FlxEmitter(20, 20);
		emitter.setPosition(pointX, pointY);

		for (i in 0...30)
		{
			var p = new FlxParticle();
			var sizep = Std.random(4) + 1;
			p.makeGraphic(sizep, sizep, FlxColor.fromRGB(180, 32, 42));
			p.setSize(sizep, sizep);
			p.exists = false;
			emitter.add(p);
		}

		emitter.allowCollisions = FlxObject.ANY;
		emitter.acceleration.start.min.y = 50;
		emitter.acceleration.start.max.y = 100;
		emitter.acceleration.end.min.y = 50;
		emitter.acceleration.end.max.y = 100;
		this.stage.emitters.add(emitter);
		emitter.start(true, 5, 20);

		FlxG.camera.shake(0.01, 0.2);
		var color = FlxColor.WHITE;
		color.alpha = 60;
		FlxG.camera.flash(color, 0.5, true);
	}

	public function setAnimation():Void
	{
		this.animation.add("idle", [0, 1, 2, 3], 10);
		this.animation.add("walk", [4, 5, 6, 7], 10);
	}
}
