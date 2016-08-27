package;

import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.FlxG;

class Enemy extends FlxSprite
{
    //#################################################################

    public var AttackStrength : Float;
    public var MaxHealth      : Float;
    public var CurrentHealth  : Float;
    public var Aggressivity   : Float;
    
    private var _playState : PlayState;

    //#################################################################

    public function new(attackStrength: Float, maxHealth: Float, aggressivity: Float, playState: PlayState)
    {
        super();

        AttackStrength = attackStrength;
        MaxHealth      = maxHealth;
        CurrentHealth  = maxHealth;
        Aggressivity   = aggressivity;

        _playState = playState;

        makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 0, 255));
        setPosition(128, 160);

        drag        = GameProperties.EnemyMovementDrag;
        maxVelocity = GameProperties.EnemyMovementMaxVelocity;
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);

        doMovement();
        FlxG.collide(this, _playState.level.collisionMap);
    }

    //#################################################################

    function doMovement()
    {
        var playerVector = new FlxVector(_playState.player.x, _playState.player.y);
        var enemyVector = new FlxVector(x, y);

        if(playerVector.dist(enemyVector) <= Aggressivity * GameProperties.TileSize
            && playerVector.dist(enemyVector) > GameProperties.TileSize)
        {
            var direction = playerVector.subtractNew(enemyVector).normalize();
            acceleration.set(
                direction.x * GameProperties.EnemyMovementAccelerationScale,
                direction.y * GameProperties.EnemyMovementAccelerationScale
            );
        }
        else
        {
            acceleration.set(0, 0);
        }
    }

    //#################################################################

    public override function draw()
    {
        super.draw();
    }

    //#################################################################
}