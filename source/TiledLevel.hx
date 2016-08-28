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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.io.Path;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	private var tileSet:TiledTileSet;
	
	
	public var patchType : Int = 1;
	public var WorldPosX : Int = 0;
	public var WorldPosY : Int = 0;
	public var levelPath : String = "";
	
	public var levelChest : FlxSprite;
	public var chestinLevelFound : Bool = false;
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
		// Array of tilemaps used for collision
	public var topTiles:FlxGroup;
	
	public var collisionMap : FlxSpriteGroup;
	
	public var exits : FlxTypedGroup<Exit>;
	
	public var enemies : FlxTypedGroup<Enemy>;
	public var npcs    : FlxTypedGroup<NPC>;
	
	public var coins : FlxSpriteGroup;

	private var enemyAreas : FlxSpriteGroup;
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		levelPath = tiledLevel ;
		
		foregroundTiles = new FlxGroup();
		topTiles = new FlxGroup();
		collisionMap = new FlxSpriteGroup();
		
		exits = new FlxTypedGroup<Exit>();
		
		enemyAreas = new FlxSpriteGroup();
		enemies = new FlxTypedGroup<Enemy>();
		npcs = new FlxTypedGroup<NPC>();
		
		coins  = new FlxSpriteGroup();
		
		levelChest = new FlxSprite(-200, -200);
		//levelChest.makeGraphic(GameProperties.TileSize, GameProperties.TileSize, FlxColor.CYAN);
		levelChest.loadGraphic(AssetPaths.chest__png, true, 16, 16);
		levelChest.animation.add("idle");
		levelChest.animation.play("idle");
		
		levelChest.alive = false;
		levelChest.immovable = true;
		
		
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
					
					if (tileLayer.name == "top")
					{
						var tileType : Int = tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						topTiles.add(s);
					}
					else
					{
						var tileType : Int = tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						foregroundTiles.add(s);
						CreateCollisionTile(i, j, tileType);
					}
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
		else if (rowIndex == 1 ||rowIndex == 2)
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
			case "merchant":
				var type : String = o.properties.get("type");
				if (type == "merchant") 
				{
					npcs.add(new Merchant(x, y));
				}
				else if (type == "trainer")
				{
					npcs.add(new Trainer(x, y));
				}
				else if(type == "healer")
				{
					npcs.add(new Healer(x, y));
				}
			case "enemy_area":
				//trace("loaded enemy area for map" + levelPath);
				var s : FlxSprite = new FlxSprite(x, y);
				var w : Int = o.width;
				var h : Int = o.height;
				s.makeGraphic(w, h);
				enemyAreas.add(s);
			case "chest":
				levelChest.setPosition(x, y);
				chestinLevelFound = true;
		}
	}
	
	public function spawnEnemies(state:PlayState)
	{
		if (enemyAreas.length == 0)
		{
			trace("no areas to spawn enemies in " + levelPath);
		}
		else
		{
			enemyAreas.forEach(
			function (s:FlxSprite) : Void 
			{
				var sizeinTiles : Float = s.width * s.height / GameProperties.TileSize / GameProperties.TileSize;
				
				var N : Int = Std.int(sizeinTiles / 25) +1;
				
				for (n in 0...N)
				{
					var enemy = new Enemy(GameProperties.EnemyDamageDefault, GameProperties.EnemyHealthDefault, 5, state);
					
					var ex : Float = GameProperties.rng.float(s.x, s.x + s.width);
					var ey : Float = GameProperties.rng.float(s.y, s.y + s.height);
					enemy.setPosition(ex, ey);
					enemies.add(enemy);
				}
			} );
		}
		//TODO spawn multiple enemies per area
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
	
	public function spawnCoins(enemy:Enemy) 
	{
		var N : Int = GameProperties.rng.int(5, 6);
		for (i in 0...N)
		{
			var coinAngle : Float = 2*Math.PI / N * i;
			
			var s: FlxSprite = new FlxSprite(enemy.x + 8, enemy.y + 8);
			
			//s.makeGraphic(6, 6, FlxColor.YELLOW);
			s.loadGraphic(AssetPaths.gems__png, true, 8, 8);
			s.animation.add("idle", [GameProperties.rng.int(0, 6)], 30, true);
			s.animation.play("idle");
			
			
			s.velocity.set(Math.cos(coinAngle) * 120, Math.sin(coinAngle) * 120);
			s.drag.set(250, 250);
			
			s.offset.set(0, -2);
			s.elasticity = 0.5;
			
			FlxTween.tween(s.offset, { y:3 }, 0.75, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG, startDelay:GameProperties.rng.float(0, 0.5) } );
			
			
			coins.add(s);
			
		}
	}
	
	public function updateChest()
	{
		if (enemies.length > 0)
		{
			npcs.forEach(function (n:NPC) : Void 
			{
				n.alpha = 0;
				n.alive = false;
			});
		}
		else
		{
			npcs.forEach(function (n:NPC) : Void 
			{
				n.alpha = 1;
				n.alive = true;
			});
		}
		
		if (patchType == 3)
		{
			if (enemies.length <= 0 )
			{
				ActivateChest();
			}
			
		}
		if (FlxG.keys.justPressed.F4)
		{
			ActivateChest();
		}
	}
	
	function ActivateChest() 
	{
		if (levelChest.alpha != 1.0 && chestinLevelFound)
		{
			//trace (levelChest.x + " " + levelChest.y);
			levelChest.alpha  = 1.0;
		}
		
		// spawn particles, etc...
	}
	
	public function spawnChest() : Bool
	{
		//trace ("tiledlevel.spawnchest");
		if (chestinLevelFound == false)
		{
			trace ("no chest in level found " + levelPath + " " + levelChest.x + " " + levelChest.y );
			// no chest spawned
			return false;
		}
		trace ("spawn chest");
		levelChest.alive = true;
		levelChest.alpha = 0;
		return true;
	}
	
	
	public function spawnMerchant() : Bool
	{
		if ( chestinLevelFound == false)
		{
			return false;
		}
		
		// spawn a random merchant/trainer/healer
		var v : Int = GameProperties.rng.int(1, 3);
		if (v == 1)
		{
			npcs.add(new Merchant(Std.int(levelChest.x), Std.int(levelChest.y)));
		}
		else if (v == 2)
		{
			npcs.add(new Trainer(Std.int(levelChest.x), Std.int(levelChest.y)));
		}
		else if (v == 3)
		{
			npcs.add(new Healer(Std.int(levelChest.x), Std.int(levelChest.y)));
		}
		return true;
	}

}