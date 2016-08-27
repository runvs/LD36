package;

import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Enemy extends FlxSprite
{
    //#################################################################

    public var AttackStrength : Float;
    public var MaxHealth      : Float;
    public var CurrentHealth  : Float;
    public var Aggressivity   : Float;
    
    private var _playState    : PlayState;
    private var _thinkTime    : Float;
    private var _rng          : FlxRandom;
    private var _playerLocked : Bool;

    //#################################################################

    public function new(attackStrength: Float, maxHealth: Float, aggressivity: Float, playState: PlayState)
    {
        super();

        AttackStrength = attackStrength;
        MaxHealth      = maxHealth;
        CurrentHealth  = maxHealth;
        Aggressivity   = aggressivity;

        _playState    = playState;
        _thinkTime    = GameProperties.EnemyMovementRandomWalkThinkTime;
        _rng          = new FlxRandom();
        _playerLocked = false;

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
    }

    //#################################################################

    function doMovement()
    {
        var playerVector = new FlxVector(_playState.player.x, _playState.player.y);
        var enemyVector = new FlxVector(x, y);

        if(playerVector.dist(enemyVector) <= Aggressivity * GameProperties.TileSize)
        {
            if(playerVector.dist(enemyVector) > GameProperties.TileSize)
            {
                _playerLocked = true;

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
        else
        {
            if(_playerLocked)
            {
                acceleration.set(0, 0);
                _playerLocked = false;
            }
            else
            {
                acceleration.set(acceleration.x / 10, acceleration.y / 10);
            }

            if(_thinkTime <= 0.0)
            {
                // Decide for a new direction to walk to
                _thinkTime += GameProperties.EnemyMovementRandomWalkThinkTime;
                
                acceleration.set(
                    _rng.float(-1.0, 1.0) * GameProperties.EnemyMovementAccelerationScale / 2,
                    _rng.float(-1.0, 1.0) * GameProperties.EnemyMovementAccelerationScale / 2
                );
            }
            else
            {
                _thinkTime -= FlxG.elapsed;
            }
        }
    }

    //#################################################################

    public override function draw()
    {
        super.draw();
    }

    //#################################################################
}