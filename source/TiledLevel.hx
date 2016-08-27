package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	
	public var collisionMap : FlxSpriteGroup;
	
	
	public var exits : FlxTypedGroup<Exit>;
	
	
	
	
	private var tileSet:TiledTileSet;
	
	public var WorldPosX : Int = 0;
	public var WorldPosY : Int = 0;
	public var levelPath : String = "";
	
	private var enemyAreas : FlxSpriteGroup;
	
	
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		levelPath = tiledLevel ;
		
		foregroundTiles = new FlxGroup();
		collisionMap = new FlxSpriteGroup();
		
		exits = new FlxTypedGroup<Exit>();
		
		enemyAreas = new FlxSpriteGroup();
		
		
		
		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;
			
			
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			tileSet = null;
			
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
				tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
				
			for (i in 0...tilemap.widthInTiles)
			{
				for (j in 0...tilemap.heightInTiles)
				{
					var tileType : Int = tilemap.getTile(i, j);
					//if (tileType == 0) continue;
					//if (tileType == 5 || tileType == 6 || tileType == 7 
					//||tileType == 16 || tileType == 17 || tileType == 26
					//||tileType == 19 || tileType == 20
					//||tileType == 29 || tileType == 30
					//||tileType == 9 || tileType == 10)
					//{
						//tilemap.setTile(i, j, 0);
						//
						//loadSpecialTile(i, j, tileType);
					//}
					//else
					//{
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						foregroundTiles.add(s);
						CreateCollisionTile(i, j, tileType);
					//}
				}
			}
		}
		
		loadObjects();
	}
	
	function CreateCollisionTile(x : Int, y : Int, type : Int) 
	{
		var cols : Int = tileSet.numCols;
		var rows : Int = tileSet.numRows;
		
		var rowIndex :Int = Std.int((type-1) / rows);
		//trace(Std.string(cols) + " " + Std.string(rows));
		
		if (rowIndex == 0)
		{	
			// no collision for tiles in row 0
			return;
		}
		else if (rowIndex == 1)
		{
			//trace("addinc collision sprite at " + Std.string(x) + " " + Std.string(y) );
			var c : FlxSprite = new FlxSprite(x * 16, y * 16);
			c.makeGraphic(16, 16);
			c.immovable = true;
			collisionMap.add(c);
		}
		else
		{
			//if (type == 1|| type == 13 || type == 14 || type == 24)
			//{
				//var c : FlxSprite = new FlxSprite(x * 32 + 9, y * 32);
				//c.makeGraphic(15, 20);
				//c.immovable = true;
				//collisionMap.add(c);
			//}
		}
	}
	
	private function loadSpecialTile(x:Int, y:Int, type : Int)
	{
		if (type == 0) return;
		
		//if (type == 5 || type == 16 || type == 17|| type ==26)
		//{
			//var bt :BreakableTile = new BreakableTile(x * 32, y * 32, type);
			
		//}
		//else if (type == 6 || type == 7)
		//{
			//var ds : FlxSprite = new FlxSprite(x * 32, y * 32);
			//ds.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//ds.animation.add("idle", (type == 6? [5] : [6]));
			//ds.animation.play("idle");
			
		//}
		//else if ( type == 9|| type == 19 || type == 29)  // onOff Switch 1
		//{
			//var s : FlxSprite = new FlxSprite(x * 32, y * 32);
			//s.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//s.origin.set(16, 32);
			//s.animation.add("idle", [(type-1)]);
			//s.animation.play("idle");
			//s.immovable = true;
			//s.ID = type +1;
			
			//CreateCollisionTile(x, y, 2);
		//}
		//else if ( type == 10 ||type == 20 ||type == 30) // onOff Block
		//{
			//var s : FlxSprite = new FlxSprite(x * 32, y * 32);
			//s.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//s.origin.set(16, 32);
			//s.animation.add("idle", [(type-1)]);
			//s.animation.play("idle");
			//s.immovable = true;
			//s.ID = type;
			
		//}
		//
	}
	
	
	public function loadObjects()
	{
		var layer:TiledObjectLayer;
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			
			//objects layer
			if (layer.name == "objects" || layer.name == "enemies")
			{
				for (o in objectLayer.objects)
				{
					loadObject( o, objectLayer);
				}
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y;
		//
		//// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;

			
		switch (o.type.toLowerCase())
		{
			case "exit":
				var dir: String = o.properties.get("direction");
				var w : Int = o.width;
				var h : Int = o.height;
				var e : Exit = new Exit(x, y, w, h);
				if (dir == "south")
				{
					e.dir = ExitDirection.SOUTH;
				}
				else if (dir == "north")
				{
					e.dir = ExitDirection.NORTH;
				}
				else if (dir == "east")
				{
					e.dir = ExitDirection.EAST;
				}
				else if (dir == "west")
				{
					e.dir = ExitDirection.WEST;
				}
				else 
				{
					throw "exit direction '" + dir + "' not known";
				}
				
				exits.add(e);
			case "enemies":
				var s : FlxSprite = new FlxSprite(x, y);
				var w : Int = o.width;
				var h : Int = o.height;
				s.makeGraphic(w, h);
				enemyAreas.add(s);
				
		}
	}
	
	public function spawnEnemies()
	{
		if (enemyAreas.length == 0)
		{
			trace("no areas to spawn enemies");
		}
		
		// TODO
	}
	
	
	public function checkExits(N:Bool, S: Bool, E:Bool,W:Bool) : Bool
	{
		var rtN : Bool = false;
		var rtS : Bool = false;
		var rtE : Bool = false;
		var rtW : Bool = false;
		
		for (i in 0...exits.length)
		{
			var e : Exit = exits.members[i];
			
			if (e.dir == ExitDirection.NORTH)
				rtN = true;
			if (e.dir == ExitDirection.SOUTH)
				rtS = true;
			if (e.dir == ExitDirection.EAST)
				rtE = true;
			if (e.dir == ExitDirection.WEST)
				rtW = true;
		}
		
		//trace("checkExits " + Std.string(N) + " " + Std.string(S) + " " + Std.string(E) + " " + Std.string(W));
		//trace("exitsthere " + Std.string(rtN) + " " + Std.string(rtS) + " " + Std.string(rtE) + " " + Std.string(rtW));
		
		return (N == rtN && S == rtS && E==rtE && W==rtW);
		
		
	}

	public function getExit(ed:ExitDirection) : Exit
	{
		for (i in 0...exits.length)
		{
			var e : Exit = exits.members[i];
			if (e.dir == ed )
			{
				return e;
			}
			
		}
		return null;
	}

}