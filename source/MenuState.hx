package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	var title : FlxText;
	var t_play : FlxText;
	var t_credits : FlxText;
	
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		title = ne
	}

	override public function update(elapsed:Float):Void
	{
		MyInput.update();
		super.update(elapsed);
		if (MyInput.AttackButtonJustPressed)
		{
			FlxG.switchState(new PlayState());
		}
	}
}
