package;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

class GameProperties
{
    // ################################################################
    // # General ######################################################
    // ################################################################
	public static var rng             : FlxRandom = new FlxRandom();
    public static var TileSize        : Int       = 16;
	public static var CoinMagnetRange : Float     = 48;
    public static var InflationValue  : Float     = Math.PI * 2.37;
    public static var SoundTimeoutMax : Float     = 0.05;
    public static var SoundTimeout    : Float     = 0.0;

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
    public static var PlayerMovementMaxVelocity  (default, null) : FlxPoint = new FlxPoint(95, 95);
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
    // # NPC ##########################################################
    // ################################################################
    public static var NPCAnnounceTextTimeout : Float    = 2.5;
    public static var NPCAnnounceTime        : Float    = 5;
    public static var NPCTalkDistance        : Float    = 4; // In tiles

    // ################################################################
    // # Merchant #####################################################
    // ################################################################
    public static var MerchantNewWaresTime        : Float    = 15;
    public static var MerchantInputDeadTime       : Float    = 0.16;
    public static var MerchantColorAvailable      : FlxColor = FlxColor.BLACK;
    public static var MerchantColorUnavailable    : FlxColor = FlxColor.RED;
    public static var MerchantColorSold           : FlxColor = FlxColor.GRAY;
	
	// ################################################################
    // # Colors #######################################################
    // ################################################################
	public static var ColorHealthBar              : FlxColor = FlxColor.fromRGB(255, 50, 50);
	public static var ColorStaminaBar             : FlxColor = FlxColor.fromRGB(55, 175, 175);
	
    // ################################################################
    // # Healer #######################################################
    // ################################################################
    public static var HealerBaseCosts        : Int      = 15;
    public static var HealerHealAmount       : Float    = 1.0;
    public static var HealerColorAvailable   : FlxColor = FlxColor.BLACK;
    public static var HealerColorUnavailable : FlxColor = FlxColor.RED;

    // ################################################################
    // # Trainer ######################################################
    // ################################################################
    public static var TrainerColorAvailable   : FlxColor = FlxColor.BLACK;
    public static var TrainerColorUnavailable : FlxColor = FlxColor.fromRGB(128, 0, 0);
    public static var TrainerStrengthBaseCost : Float    = 13;
    public static var TrainerAgilityBaseCost  : Float    = 14;
    public static var TrainerHealthBaseCost   : Float    = 23;

    //#################################################################

    public static function roundForDisplay(input : Float) : String
    {
        var dec = Std.int((input * 10) % 10);
		if (dec < 0) dec *= -1;
		return '${Std.string(Std.int(input))}.${Std.string(dec)}';
    }
}
