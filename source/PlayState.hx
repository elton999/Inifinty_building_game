package;

import entities.Bullet;
import entities.Player;
import entities.solids.Elevator;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTilemapBuffer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import scene.Floor;

class PlayState extends FlxState
{
	public var Player:Player;

	private var floor:FlxTypedGroup<FlxTilemap>;
	private var tilemap:FlxTypedGroup<FlxTilemap>;

	public var floorManagement:Floor;

	public var bullets:FlxTypedGroup<Bullet>;
	public var elevators:FlxTypedGroup<Elevator>;

	public var isChangingFloor:Bool = false;
	public var currentLevel:Int = 0;

	public override function create()
	{
		super.create();

		floorManagement = new Floor();
		floorManagement.state = this;
		floorManagement.createFirstFloor();
		this.floor = floorManagement.floor;
		this.tilemap = floorManagement.tilemap;
		this.elevators = floorManagement.elevators;
		add(this.floor);
		add(this.tilemap);
		add(this.elevators);

		this.Player = new Player(this);
		add(this.Player);

		this.bullets = new FlxTypedGroup<Bullet>();
		add(this.bullets);

		// FlxG.camera.follow(this.Player, PLATFORMER, 1);

		bgColor = FlxColor.GRAY;
		this.moveBounds();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(this.Player, this.elevators);
		FlxG.collide(this.Player, floor);
		FlxG.collide(this.bullets, floor, function(bullet:Bullet, floor:FlxTilemap)
		{
			bullet.exists = false;
		});
	}

	public function goTo(ScrollToY:Float):Void
	{
		FlxTween.tween(FlxG.camera.scroll, {x: FlxG.camera.scroll.x, y: FlxG.camera.scroll.y - ScrollToY}, 0.5, {
			onComplete: function(_)
			{
				this.isChangingFloor = false;
			}
		});
	}

	public function moveUpCamera():Void
	{
		this.goTo(240);
		this.moveBounds();
	}

	public function moveDownCamera():Void
	{
		this.goTo(-240);
		this.moveBounds();
	}

	public function moveBounds()
	{
		FlxG.worldBounds.set(0, -240 * (this.currentLevel + 1), 426, 240 * 3);
	}
}
