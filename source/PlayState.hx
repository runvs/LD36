package;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	
	public var level : TiledLevel;
	public var player: Player;
	
	override public function create():Void
	{
		super.create();
		
		level = new TiledLevel(AssetPaths.level1__tmx, this);
		add(level.foregroundTiles);
		add(level.exits);

		player = new Player();
		add(player);

		var enemy = new Enemy(100, 25);
		add(enemy);
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		
		FlxG.collide(player, level.collisionMap);
	}
	
	override public function draw () : Void
	{
		super.draw();
	}
	
	
	
}
