package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import sys.FileSystem;

class PlayState extends FlxState
{
	
	public var level : TiledLevel;
	public var player: Player;
	
	public var allLevels : Array<TiledLevel>;
	public var world : World;
	
	override public function create():Void
	{
		super.create();
		
		
		allLevels = new Array<TiledLevel>();
		world = new World();
		CreateWorld();
		
		//
		//level = new TiledLevel(AssetPaths.level1__tmx);
		//add(level.foregroundTiles);
		//add(level.exits);
		
		

		player = new Player(this);
		add(player);

		var enemy = new Enemy(100, 25, 5, this);
		add(enemy);
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		if (level != null)
		{
			level.foregroundTiles.update(elapsed);
			level.exits.update(elapsed);
		}
		
		FlxG.collide(player, level.collisionMap);
		FlxG.overlap(player, level.exits, passExit);
	}
	
	override public function draw () : Void
	{
		if (level != null)
		{
			level.foregroundTiles.draw();
			level.exits.draw();
		}
		super.draw();
		
	}
	
	public function passExit(o1:FlxObject, o2:FlxObject):Void
	{
		if (Std.is(o1, Player))
		{
			var p : Player = cast o1;
		}
		else
		{
			return;
		}
		
		if (Std.is(o2, Exit))
		{
			var e : Exit = cast o2;
			
			if (e.dir == ExitDirection.NORTH)
			{
				world.currentWorldPosY -=1;
			}
			else if (e.dir == ExitDirection.SOUTH)
			{
				world.currentWorldPosY +=1;
			}
			else if (e.dir == ExitDirection.WEST)
			{
				world.currentWorldPosX -=1;
			}
			else if (e.dir == ExitDirection.EAST)
			{
				world.currentWorldPosX +=1;
			}
			LoadLevel();

		}
		
	}
	
	private function LoadLevel()
	{
		trace("Load Level");
		var newLevel :TiledLevel = world.getLevel(world.currentWorldPosX, world.currentWorldPosY);
		if (newLevel != null)
		{
			level = newLevel;
			trace("new Level");
		}
		else
		{
			trace("WARNING: trying to load a level that is not there!");
		}
	}
	
	function CreateWorld() 
	{
		var levels : Array<String> = FileSystem.readDirectory("assets/data/");
		for (i in 0...levels.length)
		{
			
			if (levels[i].lastIndexOf(".tmx") == -1) continue;
			//trace(levels[i]);
			var l : TiledLevel = new TiledLevel("assets/data/" + levels[i]);
			allLevels.push(l);
		}
		trace("generate Levels");
		world.Generate(allLevels);
		
		LoadLevel();
		
		
	}

	
	
	
	
}
