package;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

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
	public static var PlayerMovementMaxDashLength : Float    = 40.0;
    public static var PlayerAttackBaseDamage      : Float    = 10.0;
    public static var PlayerAttackCooldown        : Float    = 0.45;
	public static var PlayerHealthMaxDefault      : Float    = 1.0;

    // ################################################################
    // # Enemy ########################################################
    // ################################################################
    public static var EnemyMovementDrag                : FlxPoint = new FlxPoint(2500, 2500);
    public static var EnemyMovementMaxVelocity         : FlxPoint = new FlxPoint(55, 55);
    public static var EnemyMovementAccelerationScale   : Float    = 350;
    public static var EnemyMovementRandomWalkThinkTime : Float    = 0.250;
	public static var EnemyAttackTimerMax			   : Float 	  = 0.45;
	public static var EnemyAttackingTime               : Float    = 0.65;
	public static var EnemyDamageDefault 			   : Float    = 0.24;
	public static var EnemyHealthDefault               : Float    = 45;

    // ################################################################
    // # Merchant #####################################################
    // ################################################################
    public static var MerchantNewWaresTime        : Float    = 5;
    public static var MerchantNewWaresTextTimeout : Float    = 2.5;
    public static var MerchantInputDeadTime       : Float    = 0.16;
    public static var MerchantColorAvailable      : FlxColor = FlxColor.BLACK;
    public static var MerchantColorUnavailable    : FlxColor = FlxColor.RED;
    public static var MerchantColorSold           : FlxColor = FlxColor.GRAY;
}
