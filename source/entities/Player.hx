package entities;

import entities.Weapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.display.Sprite;

class Player extends FlxSprite
{
	public var stage:PlayState;

	private var _weapon:Weapon;

	public function new(x:Float = 10, y:Float = 25, state:PlayState)
	{
		super(x, y);
		makeGraphic(Std.int(x), Std.int(y), FlxColor.RED);
		loadGraphic(AssetPaths.player__png, true, 64, 64);
		offset = FlxPoint.get(28, 23);
		setPosition(60, 190);
		setSize(10, 25);
		this.stage = state;
		this.stage.add(this.light);

		arms.player = this;

		_weapon = new Weapon(this.stage);
		_weapon.character = this;

		this.setAnimation();
	}

	private var light:Light = new Light();

	public var arms:PlayerArms = new PlayerArms();

	public override function update(elapsed:Float)
	{
		if (!stage.isChangingFloor)
		{
			this.inputUpdate();
			this.move();
			this.jump();
			this._weapon.update(elapsed);
			this.deformeBody();
			this.playAnimation();
			super.update(elapsed);
			this.checkCurrentLevel();
		}
	}

	public function checkCurrentLevel()
	{
		if (getScreenPosition().y < -15)
			this.stage.floorManagement.goUp();

		if (getScreenPosition().y > 255)
			this.stage.floorManagement.goDown();
	}

	private var CRight:Bool = false;
	private var CLeft:Bool = false;
	private var CJump:Bool = false;

	private function inputUpdate():Void
	{
		this.CRight = FlxG.keys.anyPressed([D, RIGHT]);
		this.CLeft = FlxG.keys.anyPressed([A, LEFT]);
		this.CJump = FlxG.keys.anyPressed([Z, SPACE, UP]);
	}

	private var _speed:Float = 100;
	private var _gravity:Float = 200;

	public var right:Bool = true;

	public function move():Void
	{
		var speed:Float = 0;
		if (this.CRight)
		{
			speed = this._speed;
			right = true;
			this.flipX = false;
		}

		if (this.CLeft)
		{
			speed = -this._speed;
			right = false;
			this.flipX = true;
		}

		velocity.set(speed, this._gravity);

		light.setPosition(x - 200, y - 200);
	}

	// Jump
	private var JumpPressedForce:Int = 0;
	private var JumpMaxForce:Int = 12;
	private var JumpPressed:Bool = false;
	private var JumpForce:Float = -250;

	private function jump():Void
	{
		this.JumpPressed = this.canJump() ? true : this.JumpPressed;
		this.JumpPressed = !this.CJump ? false : this.JumpPressed;

		if (this.isGrounded() && !this.JumpPressed)
		{
			this.JumpPressed = false;
			this.JumpPressedForce = 0;
		}
		this.addForceJump();
	}

	private function canJump():Bool
	{
		return this.isGrounded() && this.CJump;
	}

	private function addForceJump():Void
	{
		if (this.JumpPressed && this.haveForceToJump())
		{
			velocity.set(velocity.x, this.JumpForce);
			this.JumpPressedForce++;
		}
	}

	private function haveForceToJump():Bool
	{
		return this.JumpPressedForce < this.JumpMaxForce;
	}

	public var grounded:Bool = false;

	public function isGrounded():Bool
	{
		grounded = this.isTouching(FlxObject.FLOOR);
		return grounded;
	}

	private var lastframeIsOnGround = false;

	private function deformeBody()
	{
		if (lastframeIsOnGround && !this.isGrounded())
			this.stretch();
		if (!lastframeIsOnGround && this.isGrounded())
			this.smash();
		lastframeIsOnGround = this.isGrounded();

		offset.y = 23 - ((64 - 64 * scale.y) / 2);
	}

	private function stretch()
	{
		FlxTween.tween(this, {"scale.x": 0.8, "scale.y": 1.2}, 0.1, {
			onComplete: function(_)
			{
				FlxTween.tween(this, {"scale.x": 1, "scale.y": 1}, 0.1);
			},
			type: ONESHOT
		});
	}

	private function smash()
	{
		FlxTween.tween(this, {"scale.x": 1.2, "scale.y": 0.9}, 0.15, {
			onComplete: function(_)
			{
				FlxTween.tween(this, {"scale.x": 1, "scale.y": 1}, 0.1);
			},
			type: ONESHOT
		});
	}

	// end Jump
	// animation
	private function playAnimation():Void
	{
		if (this.velocity.x != 0 && this.isGrounded())
		{
			this.animation.play("run");
			this.arms.animation.play("run");
		}
		else if (!this.isGrounded())
		{
			this.animation.play("jump");
			this.arms.animation.play("jump");
		}
		else
		{
			this.animation.play("idle");
			this.arms.animation.play("idle");
		}
	}

	private function setAnimation():Void
	{
		animation.add("idle", [0, 1, 2, 3, 4], 10);
		animation.add("run", [9, 10, 11, 12, 13, 14, 15], 10);
		animation.add("jump", [16], 10);
	}

	// and animation
}
