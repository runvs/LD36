package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var title : FlxText;
	var t_play : FlxText;
	var t_credits : FlxText;
	
	var selector : Int ;
	var inputTimer : Float;
	
	var sprite : FlxSprite;
	
	var overlay : FlxSprite;
	
	var controlsEnabled :Bool;
	
	var t_loading : FlxText;
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		
		title = new FlxText(0, 0, 0, "Raiders\nof the\n Ancient Technology", 20);
		title.alignment = flixel.text.FlxTextAlign.CENTER;
		title.screenCenter(FlxAxes.X);
		title.y = FlxG.height / 3;
		
		
		add (title);
		
		t_play = new FlxText(0, 0, 0, "Play", 12);
		t_play.screenCenter(FlxAxes.X);
		t_play.y = FlxG.height * 2/3 ;
		t_credits = new FlxText(0, 0, 0, "Credits", 12);
		t_credits.screenCenter(FlxAxes.X);
		t_credits.y = FlxG.height * 2 / 3 + 16;
		
		
		add(t_play);
		add(t_credits);
		
		
		
		selector = 0;
		inputTimer  = 0;
		
		sprite = new FlxSprite(0, 0);
		sprite.loadGraphic(AssetPaths.Hero__png, true, 16, 16);
		sprite.animation.add("walk_east",  [3, 7, 11, 15], 8);
		sprite.animation.play("walk_east"); 
		add(sprite);
		
		
		overlay = new FlxSprite(0, 0);
		overlay.scrollFactor.set();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 1.0;
		FlxTween.tween(overlay, { alpha :0 }, 0.25, { onComplete : function(t) { controlsEnabled = true; }} );
		add(overlay);

		
		t_loading = new FlxText(0, 0, 0, "Creating Level\n (please be patient)", 12);
		t_loading.screenCenter(FlxAxes.XY);
		t_loading.alpha = 0;
		add(t_loading);
		
	}
	

	override public function update(elapsed:Float):Void
	{
		
		if (controlsEnabled)
		{
			MyInput.update();
			super.update(elapsed);

			inputTimer -= elapsed;
			//trace(selector);
			
			if (inputTimer <= 0)
			{
				var vx : Float = MyInput.xVal * 500;
				var vy : Float = MyInput.yVal * 500;
				var l : Float = Math.sqrt(vx * vx + vy * vy);

				if (l >= 25)
				{
					if(vy > 0)
					{
						//trace("down");
						selector += 1;
						inputTimer = 0.25;
					}
					else
					{
						//trace("up");
						selector -= 1;
						inputTimer = 0.25;
					}
				}
			}
			
			if (selector < 0 )
			{
				selector = 1;
			}
			if (selector > 1)
			{
				selector = 0;
			}
			
			if (selector == 0)
			{
				sprite.setPosition(t_play.x - 24, t_play.y);
				if (MyInput.DashButtonJustPressed ||MyInput.AttackButtonJustPressed)
				{
					StartGame();
				}
			}
			else if (selector == 1)
			{
				sprite.setPosition(t_credits.x - 24, t_credits.y);
				if (MyInput.DashButtonJustPressed ||MyInput.AttackButtonJustPressed)
				{
					FlxG.switchState(new CreditsState());
				}
			}
		}
		
	}
	
	function StartGame() 
	{
		
		controlsEnabled = false;
		FlxTween.tween(t_loading, { alpha: 1.0 }, 0.5);
		FlxTween.tween(overlay, { alpha: 1.0 }, 0.35, {onComplete:function(t){FlxG.switchState(new  PlayState());}});
		
	}
}
