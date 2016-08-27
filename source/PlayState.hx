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

		//var enemy = new Enemy(100, 25, 5, this);
		//add(enemy);
		FlxG.camera.follow(player);
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		if (level != null)
		{
			level.foregroundTiles.update(elapsed);
			level.exits.update(elapsed);
			level.enemies.update(elapsed);
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
			level.enemies.draw();
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
			
		
			TransitionLevel(e);
			

		}
		
	}
	
	private function TransitionLevel(e : Exit)
	{
		//trace("Load Level");
	
		var newPosX : Int = world.currentWorldPosX;
		var newPosY : Int = world.currentWorldPosY;
		if (e.dir == ExitDirection.NORTH)
		{
			newPosY -=1;
		}
		else if (e.dir == ExitDirection.SOUTH)
		{
			newPosY +=1;
		}
		else if (e.dir == ExitDirection.WEST)
		{
			newPosX -=1;
		}
		else if (e.dir == ExitDirection.EAST)
		{
			newPosX +=1;
		}
		
		
		var newLevel :TiledLevel = world.getLevel(newPosX, newPosY);
		if (newLevel != null)
		{
			world.currentWorldPosX = newPosX;
			world.currentWorldPosY = newPosY;
			level = newLevel;
			trace("new Level " + level.levelPath);
			FlxG.camera.setScrollBoundsRect(0, 0, level.fullWidth, level.fullHeight, true);

			var enter : ExitDirection = ExitDirection.EAST;
			var offsetX : Float  = 0;
			var offsetY : Float = 0 ;
			if (e.dir == ExitDirection.NORTH)
			{
				enter = ExitDirection.SOUTH;
				offsetY = -24;
			}
			else if (e.dir == ExitDirection.SOUTH)
			{
				enter = ExitDirection.NORTH;
				offsetY = 24 + e.height;
			}
			else if (e.dir == ExitDirection.EAST)
			{
				enter = ExitDirection.WEST;
				offsetX = 24 + e.width;
			}
			else if (e.dir == ExitDirection.WEST)
			{
				enter = ExitDirection.EAST;
				offsetX = -24 ;
			}	
			

			var exit : Exit = level.getExit(enter);
			if (exit == null)
			{
				trace("WARNING: no exit found");
				player.setPosition(offsetX, offsetY);
				
			}
			else
			{
				player.setPosition(exit.x + offsetX, exit.y + offsetY);
			}
		}
		else
		{
			trace("WARNING: trying to load a level that is not there!");
		}
	}
	
	
	private function LoadLevel()
	{
		trace("Load Level");
		var newLevel :TiledLevel = world.getLevel(world.currentWorldPosX, world.currentWorldPosY);
		if (newLevel != null)
		{
			level = newLevel;
			//trace("new Level");
			FlxG.camera.setScrollBoundsRect(0, 0, level.fullWidth, level.fullHeight, true);
			
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
		world.Generate(allLevels, this);
		
		LoadLevel();
		
		
	}

	
	
	
	
}
