package;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

class GameProperties
{
    // ################################################################
    // # General ######################################################
    // ################################################################
	public static var rng      : FlxRandom = new FlxRandom();
    public static var TileSize : Int       = 16;

    // ################################################################
    // # World ########################################################
    // ################################################################
	static public var WorldCurveChanceIncrease : Float = 10;
	static public var WorldCurveChanceBase     : Float = 8;

    // ################################################################
    // # Player #######################################################
    // ################################################################
    public static var PlayerMovementAcceleration  : Float    = 500.0;
    public static var PlayerMovementDrag          : FlxPoint = new FlxPoint(2500, 2500);
    public static var PlayerMovementMaxVelocity   : FlxPoint = new FlxPoint(95, 95);
    public static var PlayerMovementDashCooldown  : Float    = 1.0;
	public static var PlayerMovementMaxDashLength : Float    = 100.0;
    public static var PlayerAttackBaseDamage      : Float    = 10.0;
    public static var PlayerAttackCooldown        : Float    = 0.45;
	public static var PlyerHealthMaxDefault		  : Float 	 = 1.0;

    // ################################################################
    // # Enemy ########################################################
    // ################################################################
    public static var EnemyMovementDrag                : FlxPoint = new FlxPoint(2500, 2500);
    public static var EnemyMovementMaxVelocity         : FlxPoint = new FlxPoint(55, 55);
    public static var EnemyMovementAccelerationScale   : Float    = 350;
    public static var EnemyMovementRandomWalkThinkTime : Float    = 0.250;
	public static var EnemyAttackTimerMax			   : Float 	  = 0.45;
}
