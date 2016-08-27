package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Exit extends FlxSprite
{

	public var dir: ExitDirection;
	
	
	public function new(X:Float=0, Y:Float=0, W:Int, H : Int) 
	{
		super(X, Y);
		this.makeGraphic(W, H, FlxColor.GRAY);		
	}
	
}