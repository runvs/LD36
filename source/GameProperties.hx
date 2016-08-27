package;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

class GameProperties
{
    // ################################################################
    // # Player #######################################################
    // ################################################################
    public static var PlayerMovementAcceleration : Float = 750.0;
    public static var PlayerMovementDrag         : FlxPoint = new FlxPoint(2500, 2500);
    public static var PlayerMovementMaxVelocity  : FlxPoint = new FlxPoint(200, 200);
    public static var PlayerMovementDashCooldown : Float = 1.0;
	public static var PlayerMovementMaxDashLength : Float = 100.0;
	
	public static var rng : FlxRandom = new FlxRandom();
	static public var WorldCurveChanceIncrease : Float = 10;
	static public var WorldCurveChanceBase : Float = 8;

    public static var TileSize : Int = 16;

    // ################################################################
    // # Enemy ########################################################
    // ################################################################
    public static var EnemyMovementDrag                : FlxPoint = new FlxPoint(2500, 2500);
    public static var EnemyMovementMaxVelocity         : FlxPoint = new FlxPoint(190, 190);
    public static var EnemyMovementAccelerationScale   : Float = 750;
    public static var EnemyMovementRandomWalkThinkTime : Float = 0.250;
}
