package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Flocks extends FlxSpriteGroup
{

	
	public function new( f : FlxSprite-> Void, N : Int = 80) 
	{
		super();
		for (i in 0 ... N)
		{
			var s : FlxSprite = new FlxSprite( GameProperties.rng.float(0, FlxG.width), GameProperties.rng.float(0, FlxG.height));
			
			f(s);
			add(s);
		}
	}
	
	public override function update (elapsed : Float)
	{
		super.update(elapsed);
		for (i in 0...this.length)
		{
			
			var s : FlxSprite = this.members[i];
			//trace("World " + s.x + " " + s.y);
			//trace("Screen " + s.getScreenPosition().x + " " + s.getScreenPosition().y);
			if (s.getScreenPosition().x < -s.width - 10) s.x += FlxG.width + s.width + 10;
			if (s.getScreenPosition().x > FlxG.width + 10) s.x -= FlxG.width + s.width + 10;
			
			if (s.getScreenPosition().y < -s.height - 10) s.y += FlxG.height + 10 + s.height ;
			if (s.getScreenPosition().y > FlxG.height + 10) s.y -= FlxG.height + 10 + s.height;
		}
	}

	
}