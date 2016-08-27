package;

import flixel.math.FlxPoint;

class GameProperties
{
    // ################################################################
    public static var PlayerMovementAcceleration : Float = 750.0;
    public static var PlayerMovementDrag         : FlxPoint = new FlxPoint(2500, 2500);
    public static var PlayerMovementMaxVelocity  : FlxPoint = new FlxPoint(200, 200);
    public static var PlayerMovementDashCooldown : Float = 1.0;
}