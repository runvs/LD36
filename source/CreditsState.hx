package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class CreditsState extends FlxState
{
	var text : FlxText;
	var timer : Float = 0;
	
	private var title : FlxText;
	
	override public function create():Void
	{
		
	
		
		
		title = new FlxText(0, 0, 0, "Raiders\nof the\n Ancient Technology", 20);
		title.alignment = flixel.text.FlxTextAlign.CENTER;
		title.screenCenter(FlxAxes.X);
		title.y = FlxG.height / 3;
		add(title);
		
		text = new FlxText(100, 0, 0, "", 12);
		text.text = "A game by\n\n" +
		"Julian Dinges\n-code-\n\n@xXBloodyOrange\n-graphics-" + 
		"\n\nSimon  Weis \n-code-\n\n" +
		"music by jaws vs paws, CC-by-nc-sa\nobtained from freemusicarchive.org\n\n\n" +
		"created  for  LDJAM36 \n2016-08-27  to  2016-08-28\n\n" +
		"Tools  used\n HaxeFlixel, Tiled, Aseprite, \nSmartTimelapse, SFXR,\nspeedcrunch, cygwin";
		text.alignment = flixel.text.FlxTextAlign.CENTER;
		text.screenCenter(FlxAxes.X);
		add(text);
		text.alpha = 0;
		FlxTween.tween(text, { alpha:1 }, 0.5);
	}
	
	public override function update (elapsed : Float) : Void
	{
		super.update(elapsed);
		MyInput.update();
		
		var vel : Float = timer * 30;
		if (vel >= 30)
		vel = 30;
		text.y = 350 - vel * timer;
		
		title.y =  FlxG.height / 3 - vel * timer;
		
		
		timer += elapsed;
		if (timer >= 0.5)
		{
			if (FlxG.keys.pressed.ANY || MyInput.AttackButtonJustPressed)
			{
				FlxG.switchState(new MenuState());
			}
		}
		if (timer >= 35)
		{
			FlxG.switchState(new MenuState());
		}
	}

	
}