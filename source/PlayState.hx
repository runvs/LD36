package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
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

		player = new Player(this);
		add(player);

		FlxG.camera.follow(player);
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		clearEnemies();
		super.update(elapsed);
		if (level != null)
		{
			level.foregroundTiles.update(elapsed);
			level.exits.update(elapsed);
			level.enemies.update(elapsed);
			level.npcs.update(elapsed);
			level.coins.update(elapsed);
			level.updateChest();
		}

		FlxG.collide(level.enemies, level.collisionMap);
		
		FlxG.collide(player, level.collisionMap);
		FlxG.overlap(player, level.exits, passExit);
		FlxG.collide(player, level.enemies);
		FlxG.collide(level.enemies, level.enemies);
		FlxG.collide(level.coins, level.collisionMap);
		FlxG.overlap(player, level.coins, pickupCoin);
		if (level.chestspawned && level.levelChest.alpha >= 0.95)
		{
			FlxG.collide(player, level.levelChest);
		}
		
		level.enemies.forEach(
		function (e:Enemy) : Void 
		{ 
		
			if (e._attackingUnderlay.alpha >= 0.51 && e._attackingUnderlay.alive == true)
			{
				//trace(e._attackingUnderlay.alpha);
				
				if (FlxG.pixelPerfectOverlap(e._attackingUnderlay, player,1))
				{
					player.takeDamage(e.AttackStrength);
					e._attackingUnderlay.alive = false;
					FlxG.camera.shake(0.005, 0.25);
				}
			
			}
		} );
	
		if (player.alive == false)
		{
			RespawnInCity();
		}
	}
	
	public function pickupCoin(o1:FlxObject, o2:FlxObject):Void
	{
		if ( o2.alive)
		{
			o2.alive = false;
			player.pickUpCoins();
		}
	}
	
	override public function draw () : Void
	{
		if (level != null)
		{
			level.foregroundTiles.draw();
			level.enemies.forEach(function(e:Enemy) { e.drawUnderlay(); } );
			level.exits.draw();
			level.topTiles.draw();
			level.enemies.draw();
			
			if ( level.levelChest.alive)
			{
				level.levelChest.draw();
			}
			
			level.npcs.draw();
			level.coins.draw();
		}
		super.draw();
		
		player.drawHud();
		level.npcs.forEach(function(npc) { if(npc.alive) {npc.drawHud(); }});
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
				player.velocity.set();
				player.acceleration.set();
				
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

	private function clearEnemies() : Void 
	{
		{
			var n : FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
		
			level.enemies.forEach(function(e:Enemy) : Void { if (e.alive) n.add(e); } );
			level.enemies = n;
		}
		
		{
		var n2 : FlxSpriteGroup = new FlxSpriteGroup();
		
		level.coins.forEach(function(s:FlxSprite) : Void { if (s.alive) n2.add(s); } );
		level.coins = n2;
		}
		
	}
	
	
	function RespawnInCity() 
	{
		player.restoreHealth();
		player.dropAllItems();
		world.currentWorldPosX = 15;
		world.currentWorldPosY = 15;
		player.setPosition(8 * GameProperties.TileSize, 4 * GameProperties.TileSize);
		player.alive = true;
		LoadLevel();
	}
}
