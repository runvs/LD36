package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author 
 */
class World extends FlxObject
{

	public var levels : Array<TiledLevel>;
	
	public var currentWorldPosX : Int = 0;
	public var currentWorldPosY : Int = 0;
	
	public var WorldSizeInPatchesX : Int = 30;
	public var WorldSizeInPatchesY : Int = 30;
	
	
	
	
	public function new() 
	{
		super();
		
		levels = new Array<TiledLevel>();
	}
	
	public function addLevel(path : String, X: Int, Y : Int, state:PlayState) : TiledLevel
	{
		//trace("Adding Level"  + path);
		var lOld = getLevel(X, Y);
		if ( lOld != null)
		{
			//trace ("WARNING: Overwriting Level");
			levels.remove(lOld);
			
		}
		//trace("loading level");
		var l : TiledLevel = new TiledLevel(path);
		
		//trace("setting world bounds");
		l.WorldPosX = X;
		l.WorldPosY = Y;
		
		l.spawnEnemies(state);
		
		
		//trace("pushing level to list");
		levels.push(l);
		return l;
	}
	
	public function getLevel(X:Int, Y:Int) : TiledLevel
	{
		for (i in 0 ... levels.length)
		{
			var l : TiledLevel = levels[i];
			if (l.WorldPosX == X && l.WorldPosY == Y)
			{
				return l;
			}
		}
		return null;
	}
	
	private function addConnection(patches:Array<Int>)
	{
		var numberOfRuns : Int = 0;
		while (numberOfRuns <= 9)
		{
		
			
			var i : Int = GameProperties.rng.int(0, WorldSizeInPatchesX - 1, [14,15,16]);
			var j : Int = GameProperties.rng.int(0, WorldSizeInPatchesY - 1, [14,15,16]);
			
			var idx = i + j * WorldSizeInPatchesX;
			
			
			var dir : FlxPoint = new FlxPoint(0, 0);
			if ( GameProperties.rng.bool())
			{
				dir.x = 1;
			}
			else
			{
				dir.y = 1;
			}
			if ( GameProperties.rng.bool())
			{
				dir.x *= -1;
				dir.y *= -1;
			}
			
			var offDir : FlxPoint = new FlxPoint( -dir.y, dir.x);
			
			//trace("spawning connection "+ i + " " + j);
			
			addPath(patches, dir, offDir, i, j, 6, 10);
			addPath(patches, offDir, dir, i, j, 6, 10);
			numberOfRuns += 1;
		}
	}
	
	private function addPath(patches : Array<Int>, dir:FlxPoint, offDir : FlxPoint, sx : Int = 15, sy : Int = 15, Nmin:Int = 10, Nmax : Int = 14 )
	{
		var chance : Float = 0;
		var N : Int = GameProperties.rng.int(Nmin, Nmax);
		for (i in 0...N)
		{
			if ( GameProperties.rng.bool(chance))
			{	
				chance = GameProperties.WorldCurveChanceBase;
				if (GameProperties.rng.bool())
				{
					sx += Std.int(offDir.x);
					sy += Std.int(offDir.y);
				}
				else
				{
					sx -= Std.int(offDir.x);
					sy -= Std.int(offDir.y);
				}
			}
			else
			{
				sx += Std.int(dir.x);
				sy += Std.int(dir.y);
			}
			chance += GameProperties.WorldCurveChanceIncrease;
			
			if (sx < 0 ||sx > WorldSizeInPatchesX -1)
				continue;
				
			if (sy < 0 ||sy > WorldSizeInPatchesY -1)
				continue;
			
			var idx : Int = sx + sy * WorldSizeInPatchesX;
			if ( i == N)
			{
				patches[idx] = 3;	// special end tile
			}
			else
			{
				patches[idx] = 1;
			}
		}
	}
	
	public function Generate(allLevels:Array<TiledLevel>, state : PlayState) 
	{	
		var startLevel : TiledLevel = addLevel("assets/data/start.tmx", 15, 15, state);

		var patches: Array<Int> = new Array<Int>();
		for (i in 0 ...WorldSizeInPatchesX)
		{
			for (j in 0...WorldSizeInPatchesY)
			{
				patches.push(0);
			}
		}
		
		
		var sx : Int = 15;
		var sy : Int = 15;
		
		
		var idx : Int = sx + sy * WorldSizeInPatchesX;
		patches[idx] = 2;	// start
		
		// north
		addPath(patches, new FlxPoint(0, -1), new FlxPoint(1, 0));
		
		// south
		addPath(patches, new FlxPoint(0, 1), new FlxPoint(1, 0));
		
		// east
		addPath(patches, new FlxPoint(1, 0), new FlxPoint(0,1));
		
		// west 
		addPath(patches, new FlxPoint(-1,0), new FlxPoint(0,1));
		
		
		addConnection(patches);
		
		// patches created, now create level parts respectively
		
		
		var s : String  = "";
		
		var counter : Int = 1;
		
		for (j in 1...WorldSizeInPatchesY-1)
		{
			s += "\n";
			for (i in 1...WorldSizeInPatchesX -1)
			{
				
				var idx : Int = i + j * WorldSizeInPatchesX;
				s += Std.string(patches[idx]) + " ";
				if (patches[idx] == 1 )
				{
					counter += 1;
					var idxNorth  : Int = (i)     + (j - 1 ) * WorldSizeInPatchesX;
					var idxSouth  : Int = (i)     + (j + 1 ) * WorldSizeInPatchesX;
					var idxEast   : Int = (i + 1) + (j)      * WorldSizeInPatchesX;
					var idxWest   : Int = (i - 1) + (j)      * WorldSizeInPatchesX;
					
					var bNorth    : Bool = (patches[idxNorth] != 0);
					var bSouth    : Bool = (patches[idxSouth] != 0);
					var bEast     : Bool = (patches[idxEast]  != 0);
					var bWest     : Bool = (patches[idxWest]  != 0);
					
					var depth  : Int = 0;
					
					while (true)
					{
						var myIndex : Int = GameProperties.rng.int(0, allLevels.length - 1);	// pick a random value
						
						if (allLevels[myIndex].checkExits(bNorth, bSouth, bEast, bWest))
						{
							addLevel(allLevels[myIndex].levelPath, i, j, state);
							//trace("found a fitting patch after N=" + Std.string(depth) + " iterations");
							break;
						}
						
						depth += 1;
						if (depth >= 50)
						{
							myIndex = 0;
							//trace("error: no level found, direct search");
							for (myIndex in 0 ... allLevels.length)
							{
								//trace(myIndex);
								if (allLevels[myIndex].checkExits(bNorth, bSouth, bEast, bWest))
								{
									addLevel(allLevels[myIndex].levelPath, i, j, state);
									break;
								}
							}
							trace("no fitting patch found " + i  +" " + j );
							trace(Std.string(bNorth) + " " +Std.string(bSouth) + " " +Std.string(bEast) + " " +Std.string(bWest) );
							
							break;
						}
						
					}
				}
			}
		}
		
		trace(s);
		
		currentWorldPosX = 15;
		currentWorldPosY = 15;
		trace("created a level with " + Std.string(levels.length) + " of " + Std.string(counter)  + " levels");
	}
}