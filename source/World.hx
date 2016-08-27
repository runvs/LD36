package;

import flixel.FlxObject;
import flixel.FlxSprite;

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
	
	public function addLevel(path : String, X: Int, Y : Int) : TiledLevel
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
	
	public function Generate(allLevels:Array<TiledLevel>) 
	{	
		var startLevel : TiledLevel = addLevel("assets/data/start.tmx", 15, 15);

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
		
		
		// north path
		var chance : Float = 0;
		for (i in 0...GameProperties.rng.int(10,14))
		{
			
			if ( GameProperties.rng.bool(chance))
			{	
				chance = GameProperties.WorldCurveChanceBase;
				if (GameProperties.rng.bool())
				{
					sx += 1;
				}
				else
				{
					sx -= 1;
				}
			}
			else
			{
				sy -= 1;
			}
			chance += GameProperties.WorldCurveChanceIncrease;
			
			var idx : Int = sx + sy * WorldSizeInPatchesX;
			patches[idx] = 1;
		}
		
		sx = 15;
		sy = 15;
		// south path
		chance = 0;
		for (i in 0...GameProperties.rng.int(10,14))
		{
			chance += GameProperties.WorldCurveChanceIncrease;
			if ( GameProperties.rng.bool(chance))
			{	
				chance = GameProperties.WorldCurveChanceBase;
				if (GameProperties.rng.bool())
				{
					sx += 1;
				}
				else
				{
					sx -= 1;
				}
			}
			else
			{
				sy += 1;
			}
			
			var idx : Int = sx + sy * WorldSizeInPatchesX;
			patches[idx] = 1;
		}
		//
		sx = 15;
		sy = 15;
		// west path
		chance = 0;
		for (i in 0...GameProperties.rng.int(10,14))
		{
			
			if ( GameProperties.rng.bool(chance))
			{	
				chance = GameProperties.WorldCurveChanceBase;
				if (GameProperties.rng.bool())
				{
					sy += 1;
				}
				else
				{
					sy -= 1;
				}
			}
			else
			{
				sx -= 1;
			}
			
			chance += GameProperties.WorldCurveChanceIncrease;
			
			var idx : Int = sx + sy * WorldSizeInPatchesX;
			patches[idx] = 1;
		}
		//
		sx = 15;
		sy = 15;
		// east path
		chance = 0;
		for (i in 0...GameProperties.rng.int(10,14))
		{		if ( GameProperties.rng.bool(chance))
			{	
				chance = GameProperties.WorldCurveChanceBase;
				if (GameProperties.rng.bool())
				{
					sy += 1;
				}
				else
				{
					sy -= 1;
				}
			}
			else
			{
				sx += 1;
			}
			chance += GameProperties.WorldCurveChanceIncrease;
			var idx : Int = sx + sy * WorldSizeInPatchesX;
			patches[idx] = 1;
		}
		
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
							addLevel(allLevels[myIndex].levelPath, i, j);
							trace("found a fitting patch after N=" + Std.string(depth) + " iterations");
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
									addLevel(allLevels[myIndex].levelPath, i, j);
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