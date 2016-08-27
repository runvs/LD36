package;

import flixel.math.FlxPoint;

class GameProperties
{
    // ################################################################
    // # General ######################################################
    // ################################################################
    public static var TileSize : Int = 32;

    // ################################################################
    // # Player #######################################################
    // ################################################################
    public static var PlayerMovementAcceleration  : Float = 750.0;
    public static var PlayerMovementDrag          : FlxPoint = new FlxPoint(2500, 2500);
    public static var PlayerMovementMaxVelocity   : FlxPoint = new FlxPoint(200, 200);
    public static var PlayerMovementDashCooldown  : Float = 1.0;
    public static var PlayerMovementMaxDashLength : Float = 100.0;

    // ################################################################
    // # Enemy ########################################################
    // ################################################################
    public static var EnemyMovementDrag                : FlxPoint = new FlxPoint(2500, 2500);
    public static var EnemyMovementMaxVelocity         : FlxPoint = new FlxPoint(190, 190);
    public static var EnemyMovementAccelerationScale   : Float = 750;
    public static var EnemyMovementRandomWalkThinkTime : Float = 0.250;
}