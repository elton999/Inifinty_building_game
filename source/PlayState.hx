package;

import entities.actors.Bullet;
import entities.actors.Enemy;
import entities.actors.Player;
import entities.solids.Elevator;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTilemapBuffer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import scene.Floor;
import ui.HUD;

class PlayState extends FlxState
{
	public var Player:Player;
	public var HUD:HUD;

	public var floor:FlxTypedGroup<FlxTilemap>;

	private var tilemap:FlxTypedGroup<FlxTilemap>;

	public var floorManagement:Floor;

	public var bullets:FlxTypedGroup<Bullet>;
	public var environments:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var elevators:FlxTypedGroup<Elevator>;
	public var enemies:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();

	public var emitters:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup<FlxEmitter>();

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
		add(environments);
		add(this.elevators);
		add(this.enemies);
		add(this.emitters);

		this.Player = new Player(this);
		add(this.Player);
		add(this.Player.arms);

		this.bullets = new FlxTypedGroup<Bullet>();
		add(this.bullets);

		this.HUD = new HUD();
		this.HUD.state = this;
		add(this.HUD.timerSecondsText);
		add(this.HUD.timerMilisecondsText);
		add(this.HUD.currentLevelText);
		add(this.HUD.pointsTexts);
		add(this.HUD.lifesText);

		// FlxG.camera.follow(this.Player, PLATFORMER, 1);

		bgColor = FlxColor.GRAY;
		this.moveBounds();
	}

	override public function update(elapsed:Float)
	{
		if (canUpdate())
		{
			super.update(elapsed);
			this.HUD.update(elapsed);
			timerDelayDemage -= elapsed;
		}
		if (isFreazeEfx)
		{
			timerFreaze += elapsed;
			if (timerFreaze >= maxTimeFreaze)
				isFreazeEfx = false;
		}
		else
			timerFreaze = 0;

		this.UpdateCollision();
	}

	public function UpdateCollision()
	{
		FlxG.collide(this.Player, this.elevators);
		FlxG.collide(this.Player, floor);
		FlxG.collide(this.enemies, this.enemies);
		FlxG.collide(this.bullets, floor, function(bullet:Bullet, floor:FlxTilemap)
		{
			bullet.destroyBullet();
			bullet.light.exists = false;
		});

		FlxG.collide(this.emitters, floor);

		FlxG.collide(this.bullets, this.enemies, function(bullet:Bullet, enemy:Enemy)
		{
			bullet.destroyBullet();
			bullet.light.exists = false;
			isFreazeEfx = true;
			enemy.demage(bullet.x, bullet.y);
			HUD.points++;
		});

		FlxG.collide(this.Player, this.enemies, function(player:Player, enemy:Enemy)
		{
			this.Player.demage();
		});
	}

	public var timerDelayDemage:Float = 0;
	public var timerDelayDemageMax:Float = 1;
	public var isChangingFloor:Bool = false;
	public var isFreazeEfx:Bool = false;
	public var timerFreaze:Float = 0;
	public var maxTimeFreaze:Float = 0.1;

	public function canUpdate():Bool
	{
		return !isChangingFloor && !isFreazeEfx;
	}

	public function goTo(ScrollToY:Float):Void
	{
		FlxTween.tween(FlxG.camera.scroll, {x: FlxG.camera.scroll.x, y: FlxG.camera.scroll.y - ScrollToY}, 0.3, {
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
