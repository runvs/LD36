package;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

class GameProperties
{
    // ################################################################
    public static var PlayerMovementAcceleration : Float = 750.0;
    public static var PlayerMovementDrag         : FlxPoint = new FlxPoint(2500, 2500);
    public static var PlayerMovementMaxVelocity  : FlxPoint = new FlxPoint(200, 200);
    public static var PlayerMovementDashCooldown : Float = 1.0;
	
	public static var rng : FlxRandom = new FlxRandom();
	static public var WorldCurveChanceIncrease : Float = 10;
	static public var WorldCurveChanceBase : Float = 8;
}
