package entities;

import entities.Weapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public var stage:PlayState;

	private var _weapon:Weapon;

	public function new(x:Float = 10, y:Float = 25, state:PlayState)
	{
		super(x, y);
		makeGraphic(Std.int(x), Std.int(y), FlxColor.RED);
		setPosition(60, 190);
		setSize(10, 25);
		this.stage = state;

		_weapon = new Weapon(this.stage);
		_weapon.character = this;
	}

	public override function update(elapsed:Float)
	{
		if (!stage.isChangingFloor)
		{
			this.inputUpdate();
			this.move();
			this.jump();
			this._weapon.update(elapsed);
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
		}

		if (this.CLeft)
		{
			speed = -this._speed;
			right = false;
		}

		velocity.set(speed, this._gravity);
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

	private function isGrounded():Bool
	{
		return this.isTouching(FlxObject.FLOOR);
	}

	// end Jump
}
