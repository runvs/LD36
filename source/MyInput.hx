package;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

/**
 * ...
 * @author 
 */
class MyInput
{

	public static var xVal : Float = 0;
	public static var yVal : Float = 0;
	public static var DashButtonJustPressed : Bool;
	public static var AttackButtonJustPressed : Bool;
	public static var SpecialButtonJustPressed : Bool;
	public static var SpecialButtonPressed : Bool;
	
	public static function update ()
	{
		DashButtonJustPressed = false;
		AttackButtonJustPressed = false;
		SpecialButtonJustPressed = false;
		
		xVal = 0;
		yVal = 0;
		var gp : FlxGamepad = FlxG.gamepads.firstActive;
		if (gp != null)
		{
			xVal = gp.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			yVal = gp.getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			DashButtonJustPressed = gp.justPressed.X;
			AttackButtonJustPressed = gp.justPressed.A;
			SpecialButtonJustPressed = gp.justPressed.B;
			SpecialButtonPressed = gp.pressed.B;
		}
		
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
		{
			xVal = 1;
		}
		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
		{
			xVal = -1;
		}
		
		if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
		{
			yVal = -1;
		}
		if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
		{
			yVal = 1;
		}
		if (FlxG.keys.justPressed.C)
		{
			DashButtonJustPressed = true;
		}
		if (FlxG.keys.justPressed.X)
		{
			AttackButtonJustPressed= true;
		}
		if (FlxG.keys.justPressed.D)
		{
			SpecialButtonJustPressed = true;
		}
		
	}
	
}