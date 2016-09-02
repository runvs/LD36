package;

/**
 * ...
 * @author 
 */
class LevelSorter
{
	
	var levelsN : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsS : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsE : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsW : Array<TiledLevel> = new Array<TiledLevel>();
	
	var levelsNS : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsEW : Array<TiledLevel> = new Array<TiledLevel>();
	
	var levelsNSE : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsNSW : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsNEW : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsSEW : Array<TiledLevel> = new Array<TiledLevel>();
	
	var levelsNE : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsNW : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsSE : Array<TiledLevel> = new Array<TiledLevel>();
	var levelsSW : Array<TiledLevel> = new Array<TiledLevel>();
	
	var levelsNSEW : Array<TiledLevel> = new Array<TiledLevel>();

	public function new() 
	{
	}
	
	
	public function getRandomLevel(N:Bool, S: Bool, E:Bool, W:Bool) : TiledLevel
	{
		 var list : Array<TiledLevel> = null;

		if (N == true && S == false && E == false && W == false)
		{
			list = levelsN;
		}
		else if (N == false && S == true && E == false && W == false)
		{
			list = levelsS;
		}
		else if (N == false && S == false && E == true && W == false)
		{
			list = levelsE;
		}
		else if (N == false && S == false && E == false && W == true)
		{
			list = levelsW;
		}

		else if (N == true && S == true && E == false && W == false)
		{
			list = levelsNS;
		}
		else if (N == false && S == false && E == true && W == true)
		{
			list = levelsEW;
		}
		
		else if (N == true && S == true && E == true && W == false)
		{
			list = levelsNSE;
		}
		else if (N == true && S == true && E == false && W == true)
		{
			list = levelsNSW;
		}
		else if (N == true && S == false && E == true && W == true)
		{
			list = levelsNEW;
		}
		else if (N == false && S == true && E == true && W == true)
		{
			list = levelsSEW;
		}
		
		else if (N == true && S == false && E == true && W == false)
		{
			list = levelsNE;
		}
		else if (N == true && S == false && E == false && W == true)
		{
			list = levelsNW;
		}
		else if (N == false && S == true && E == true && W == false)
		{
			list = levelsSE;
		}
		else if (N == false && S == true && E == false && W == true)
		{
			list = levelsSW;
		}
		else if (N == true && S == true && E == true && W == true)
		{
			list = levelsNSEW;
		}
		 
		 
		 if (list == null) return null;
		 return list[GameProperties.rng.int(0, list.length-1)];
	}
	
	
	public function AddLevels(allLevels:Array<TiledLevel>)
	{
		for (i in 0...allLevels.length)
		{
			var l : TiledLevel = allLevels[i];
			if (l.checkExits(true, false, false, false))
				levelsN.push(l);
			else if (l.checkExits(false, true, false, false))
				levelsS.push(l);
			else if (l.checkExits(false, false, true, false))
				levelsE.push(l);
			else if (l.checkExits(false, false, false, true))
				levelsW.push(l);
				
			else if (l.checkExits(true, true, false, false))
				levelsNS.push(l);
			else if (l.checkExits(false, false, true, true))
				levelsEW.push(l);
				
			else if (l.checkExits(true, true, true, false))
				levelsNSE.push(l);
			else if (l.checkExits(true, true, false, true))
				levelsNSW.push(l);
			else if (l.checkExits(true, false, true, true))
				levelsNEW.push(l);
			else if (l.checkExits(false, true, true, true))
				levelsSEW.push(l);
				
			else if (l.checkExits(true, false, true, false))
				levelsNE.push(l);
			else if (l.checkExits(false, true, true, false))
				levelsSE.push(l);
			else if (l.checkExits(false, true, false, true))
				levelsSW.push(l);
			else if (l.checkExits(true, false, false, true))
				levelsNW.push(l);
				
			else if (l.checkExits(true, true, true, true))
				levelsNSEW.push(l);
			else
			{
				trace ("Warning: Adding a level with no exits");
			}
				
		}
		
		trace(levelsN.length);
		trace(levelsNS.length);
	
	}
	
}