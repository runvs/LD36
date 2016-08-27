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
	
	
	
	override public function create():Void
	{
		super.create();
		
		level = new TiledLevel(AssetPaths.level1__tmx, this);
		add(level.foregroundTiles);
		add(level.exits);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
	}
	
	override public function draw () : Void
	{
		super.draw();
	}
	
	
	
}
