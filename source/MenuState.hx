package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
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
