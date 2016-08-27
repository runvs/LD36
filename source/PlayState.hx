package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

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
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
	}
	
	override public function draw () : Void
	{
		super.draw();
	}
	
	
	
}
