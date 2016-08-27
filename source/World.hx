package;

import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class World extends FlxObject
{

	public var levels : Array<TiledLevel>;
	
	public var currentWorldPosX : Int = 0;
	public var currentWorldPosY : Int = 0;
	
	public function new() 
	{
		super();
		
		levels = new Array<TiledLevel>();
	}
	
	public function addLevel(path : String, X: Int, Y : Int)
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
		
		addLevel("assets/data/level1.tmx", 0, 0);
		addLevel("assets/data/level2.tmx", 0, 1);
		
		trace("Created a World with " + Std.string(levels.length) + " levels");
	}
	
	
}