package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.FileSystem;

class PlayState extends FlxState
{
	
	public var level : TiledLevel;
	public var player: Player;
	
	public var allLevels : Array<TiledLevel>;
	public var world : World;
	
	
	public var TechnologyFound : Int;
	private var _technologyFoundText : FlxText;
	
	private var overlay : FlxSprite;
	private var controlsEnabled : Bool;
	var pickupSound : PitchSound;
	
	var started : Bool = false;
	
	var introText : UpcomingMessages;
	
	var _flocks : Flocks;
	
	override public function create():Void
	{
		super.create();
		
		
		allLevels = new Array<TiledLevel>();
		world = new World();
		CreateWorld();

		player = new Player(this);
		add(player);

		FlxG.camera.follow(player);
		
		TechnologyFound  = 0;
		_technologyFoundText = new FlxText(10, 48, 0, "Tech Found: 0 / 4", 10);
		_technologyFoundText.scrollFactor.set();
		
		pickupSound = new PitchSound(AssetPaths.pickup__ogg, 0.5, false);
		pickupSound.pitchMin = 0.5;
		pickupSound.pitchMin = 1.5;
		pickupSound.pitchDelta = 0.15;
		
		controlsEnabled = false;
		overlay = new FlxSprite(0, 0);
		overlay.scrollFactor.set();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 1.0;
		
		introText = new UpcomingMessages(0,0, 200, "");
		introText.screenCenter(FlxAxes.X);
		
		introText.y = FlxG.height / 2 - 100;
		
		introText.scrollFactor.set();
		
		CreateFlocksFront();
		
	}

	override public function update(elapsed:Float):Void
	{
		
		if (!started)
		{
			started = true;
			FlxTween.tween(overlay, { alpha :0 }, 11, { onComplete : function(t) { controlsEnabled = true; }} );
			
			FlxTween.tween(introText, { alpha : 0 }, 1.0, { startDelay : 10 } );
			
			
			var str : String = "This is the temple of Angkor Wat.\n" +
			"I expect some ancient technology.\nAccording to my sources, there must be 4 chests.\n";
			
			if (MyInput.GamePadConnected)
			{
				str += "Controls (XBox360):\nMove - Left Stick\nAttack - A\nDash - X\nInventory - Y";
			}
			else
			{
				str += "Controls (Keys):\nMove - Arrows\nAttack - X\nDash - C\nInventory - F";
			}
			
			
			introText.SetText(str);
			
		}
		
		if (FlxG.keys.justPressed.F5)
		{
			TechnologyFound += 1;
		}
		
		
		MyInput.update();
		
		introText.update(elapsed);
		if (controlsEnabled)
		{
			_flocks.update(elapsed);
			clearEnemies();
			pickupSound.update(elapsed);
			super.update(elapsed);

			if(GameProperties.SoundTimeout > 0.0)
			{
				GameProperties.SoundTimeout -= elapsed;
			}
			

			if (level != null)
			{
				level.foregroundTiles.update(elapsed);
				level.exits.update(elapsed);
				level.enemies.update(elapsed);
				level.npcs.update(elapsed);
				level.coins.update(elapsed);
				
				updateCoins(elapsed);
				
				level.updateChest();
			}

			FlxG.collide(player, level.collisionMap);
			FlxG.overlap(player, level.exits, passExit);
			FlxG.collide(player, level.enemies);
			FlxG.collide(player, level.npcs);
			
			FlxG.collide(level.enemies, level.enemies);
			FlxG.collide(level.enemies, level.collisionMap);
			FlxG.collide(level.enemies, level.exits);
			
			FlxG.collide(level.coins, level.collisionMap);
			FlxG.overlap(player, level.coins, pickupCoin);
			if (level.chestinLevelFound && level.levelChest.alpha == 1 && level.levelChest.alive)
			{
				FlxG.collide(player, level.levelChest, function(o1:FlxObject, o2:FlxObject) 
				{ 
					o2.alive = false;
					if (Std.is(o2, FlxSprite))
					{
						var s : FlxSprite = cast o2;
						s.alpha = 0;
						FindTechnology();
					}
					
				} );
				
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
						FlxG.camera.shake(0.0085, 0.25);
					}
				
				}
			} );
		
			if (player.alive == false)
			{
				RespawnInCity();
			}
			
			if (TechnologyFound >= 4)
			{
				WinGame();
			}
		}
	}
	
	function updateCoins(elapsed:Float) 
	{
		level.coins.forEach(function(s) 
		{ 
			var dx : Float = player.x +8 - s.x - 4;
			var dy : Float = player.y + 8 - s.y - 4;
			
			var lsq  : Float = (dx * dx + dy * dy) ;
			if (lsq< GameProperties.CoinMagnetRange * GameProperties.CoinMagnetRange)
			{
				var l :Float = Math.sqrt(lsq);
				dx /= l;
				dy /= l;
				
				s.x += dx * 32 * elapsed;
				s.y += dy * 32 * elapsed;
			}
		} );
	}
	
	function WinGame() 
	{
		controlsEnabled = false;
		FlxTween.tween(overlay, { alpha:1 }, 1.5, { onComplete:function(t) { FlxG.switchState(new MenuState()); }} );
		
	}
	
	function FindTechnology() 
	{
		TechnologyFound += 1;
		_technologyFoundText.text =  "Tech Found: " + Std.string(TechnologyFound) + " / 4";
		
	}
	
	public function pickupCoin(o1:FlxObject, o2:FlxObject):Void
	{
		if ( o2.alive)
		{
			o2.alive = false;
			if (o2.elasticity == 0.25)
			{
				player.heal(0.1 ); 
			}
			else
			{
				player.pickUpCoins(); 
			}

			if(GameProperties.SoundTimeout <= 0.0)
			{
				pickupSound.play();
				GameProperties.SoundTimeout = GameProperties.SoundTimeoutMax;
			}
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
			_flocks.draw();
			
			
		}
		super.draw();
		
		overlay.draw();
		
		if (controlsEnabled)
		{
			_technologyFoundText.draw();
			player.drawHud();
		}
		introText.draw();
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
		if (controlsEnabled == false)
		{
			return;
		}
		controlsEnabled = false;
		FlxTween.tween(overlay, { alpha:1.0 }, 0.75, {onComplete:function (t)
		{
			//overlay.alpha = 0;
			
			FlxTween.tween(overlay, { alpha:0 }, 0.5, {onComplete :function(t2){controlsEnabled = true;} });
			
			
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
					offsetY = -20;
				}
				else if (e.dir == ExitDirection.SOUTH)
				{
					enter = ExitDirection.NORTH;
					offsetY = 20 + e.height;
				}
				else if (e.dir == ExitDirection.EAST)
				{
					enter = ExitDirection.WEST;
					offsetX = 20 + e.width;
				}
				else if (e.dir == ExitDirection.WEST)
				{
					enter = ExitDirection.EAST;
					offsetX = -20 ;
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
		}});
		
		
		
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
			if (levels[i] == "start.tmx") continue;
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
		if (controlsEnabled == false)
		{
			return;
		}
		
		controlsEnabled = false;
		
		FlxTween.tween(overlay, { alpha:1 }, 0.75, { onComplete:function(t)
		{
			player.restoreHealth();
			player.velocity.set();
			player.acceleration.set();
			player.stopNpcInteraction();
			player.dropAllItems();
			player.setPosition(8 * GameProperties.TileSize, 4 * GameProperties.TileSize);
			player.alive = true;

			world.currentWorldPosX = 15;
			world.currentWorldPosY = 15;
			LoadLevel();
			overlay.alpha = 0;
			controlsEnabled = true;
		}} );		
	}
	
	function CreateFlocksFront():Void 
	{
		_flocks = new Flocks(function (s : FlxSprite):Void 
		{
			if (GameProperties.rng.bool())
			{
				s.makeGraphic(GameProperties.rng.int(1,3), GameProperties.rng.int(1,3), FlxColor.fromRGB(101, 202,0,255));
			}
			else
			{
				s.makeGraphic(GameProperties.rng.int(1,3), GameProperties.rng.int(1,3), FlxColor.fromRGB(77, 45, 25,255));
			}
			
			
			s.velocity.x = -4 + GameProperties.rng.float( -3, 3);
			s.velocity.y = 6 + GameProperties.rng.float( -2, 2);
			s.angularVelocity = (GameProperties.rng.bool() ? 1 : -1) *  10;
			s.angle = GameProperties.rng.float(0, 360);
			
			s.alpha = GameProperties.rng.float(0.45, 0.95);		
		});
		for (f in _flocks)
		{
			f.scrollFactor.set(1.05, 1.05);
		}
		//add(_flocks);
	
	}
}
