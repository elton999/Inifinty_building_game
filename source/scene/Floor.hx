package scene;

import entities.solids.Elevator;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.Json;
import lime.math.Vector2;
import openfl.Assets;

class Floor
{
	public var floor:FlxTypedGroup<FlxTilemap>;
	public var tilemap:FlxTypedGroup<FlxTilemap>;
	public var elevators:FlxTypedGroup<Elevator> = new FlxTypedGroup<Elevator>();
	public var AllFloors:Array<Array<Int>> = new Array<Array<Int>>();
	public var state:PlayState;

	var offsetX:Int = 24;

	private var level:Array<String> = [
		AssetPaths.Level_1__json,
		AssetPaths.Level_2__json,
		AssetPaths.Level_3__json,
		AssetPaths.Level_4__json,
		AssetPaths.Level_5__json
	];

	public function new()
	{
		this.firstFloor = [4, 0, 0, 0, 1];
	}

	public var firstFloor:Array<Int>;

	public function createFirstFloor()
	{
		this.floor = new FlxTypedGroup<FlxTilemap>();
		this.tilemap = new FlxTypedGroup<FlxTilemap>();
		this.create(this.firstFloor, 0);
		this.createNextFloor();
	}

	public function create(levels:Array<Int>, offsetY:Float):Void
	{
		this.AllFloors.push(levels);
		this.setPartOfFloor(offsetX, offsetY, AssetPaths.Wall_l__json);

		for (i in 0...5)
			this.setPartOfFloor(offsetX + 24 + (i * 64), offsetY, level[levels[i]]);

		this.setPartOfFloor(offsetX + 24 + (4 * 80), offsetY, AssetPaths.Wall_r__json);
	}

	private function setPartOfFloor(x:Float, y:Float, pathPartOfLevel:String):Void
	{
		this.floor.add(this.seTtileMap(x, y, "collision", pathPartOfLevel));
		this.setEntities(x, y, pathPartOfLevel);
		this.tilemap.add(this.seTtileMap(x, y, "texture", pathPartOfLevel));
		this.setDecal(x, y, pathPartOfLevel);
	}

	private function seTtileMap(x:Float, y:Float, layer:String, pathPartOfLevel:String):FlxTilemap
	{
		var map:FlxOgmo3Loader = new FlxOgmo3Loader(AssetPaths.TileSet__ogmo, pathPartOfLevel);
		var collisions:FlxTilemap = map.loadTilemap(AssetPaths.collision_tilemap__png, layer);
		collisions.setPosition(x, y);
		return collisions;
	}

	public function createNextFloor():Void
	{
		this.create(this.setNextFloor(), (this.state.currentLevel + 1) * -240);
	}

	private function setNextFloor():Array<Int>
	{
		var nextLevel:Array<Int> = new Array<Int>();
		var canChangeInRoom:Array<Int> = new Array<Int>();

		for (i in 0...5)
		{
			if (this.AllFloors[this.state.currentLevel][i] == 4)
				nextLevel.push(3);
			else
			{
				var levelPart:Int = Std.random(4);
				nextLevel.push(levelPart);
				canChangeInRoom.push(i);
			}
		}

		// give access to next level
		var changeInRoom = canChangeInRoom[Std.random(2)];
		nextLevel[changeInRoom] = 4;
		canChangeInRoom.remove(changeInRoom);

		// give access to next floor
		changeInRoom = canChangeInRoom[Std.random(1)];
		nextLevel[changeInRoom] = 1;
		return nextLevel;
	}

	private function setEntities(x:Float, y:Float, pathPartOfLevel:String):Void
	{
		var map:FlxOgmo3Loader = new FlxOgmo3Loader(AssetPaths.TileSet__ogmo, pathPartOfLevel);
		map.loadEntities(function(entity:EntityData)
		{
			if (entity.name == "elevator")
			{
				var elevator:Elevator = new Elevator();

				if (Std.random(2) == 0)
				{
					elevator.setPosition(entity.x + x, entity.y + y);
					elevator.paths.push(new Vector2(entity.x + x, entity.y + y));
					elevator.paths.push(new Vector2(entity.nodes[0].x + x, entity.nodes[0].y + y));
				}
				else
				{
					elevator.setPosition(entity.nodes[0].x + x, entity.nodes[0].y + y);
					elevator.paths.push(new Vector2(entity.nodes[0].x + x, entity.nodes[0].y + y));
					elevator.paths.push(new Vector2(entity.x + x, entity.y + y));
				}

				elevator.stage = this.state;
				elevators.add(elevator);
			}
		}, "entities");
	}

	private function setDecal(x:Float, y:Float, pathPartOfLevel:String):Void
	{
		var level:LevelData = Json.parse(Assets.getText(pathPartOfLevel));
		var path = "assets/images/environments/";
		for (layer in level.layers)
		{
			if (layer.name == "environments")
			{
				for (decal in layer.decals)
				{
					if (Std.random(4) == 0)
					{
						var environment:FlxSprite = new FlxSprite(decal.x + x, decal.y + y, path + decal.texture);
						this.state.environments.add(environment);
					}
				}
			}
		}
	}

	public function goUp():Void
	{
		this.state.isChangingFloor = true;
		this.state.currentLevel++;
		this.state.moveUpCamera();
		if (this.state.currentLevel == this.AllFloors.length - 1)
			this.createNextFloor();
	}

	public function goDown():Void
	{
		this.state.isChangingFloor = true;
		this.state.currentLevel--;
		this.state.moveDownCamera();
	}
}
