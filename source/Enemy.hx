package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Enemy extends FlxSprite
{
    //#################################################################

    public var AttackStrength : Float;
	public var AttackTimer	  : Float;
    public var MaxHealth      : Float;
    public var CurrentHealth  : Float;
    public var Aggressivity   : Float;
    
    private var _playState    : PlayState;
    private var _thinkTime    : Float;
    private var _rng          : FlxRandom;
    private var _playerLocked : Bool;
	
	private var _distanceToPlayer : Float;
	
	private var _idleTimer : Float;
	var _attacking:Bool;
	public var _attackingUnderlay : FlxSprite;
	

    //#################################################################

    public function new(attackStrength: Float, maxHealth: Float, aggressivity: Float, playState: PlayState)
    {
        super();

        AttackStrength = attackStrength;
		AttackTimer	   = 0.1;
        MaxHealth      = maxHealth;
        CurrentHealth  = maxHealth;
        Aggressivity   = aggressivity;
		_attacking 	   = false;

        _playState    = playState;
        _thinkTime    = GameProperties.EnemyMovementRandomWalkThinkTime;
        _rng          = new FlxRandom();
        _playerLocked = false;

        makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 0, 255));
        setPosition(128, 160);
		this.color = FlxColor.WHITE;

        drag        = GameProperties.EnemyMovementDrag;
        maxVelocity = GameProperties.EnemyMovementMaxVelocity;
		
		_distanceToPlayer = 0;
		_idleTimer = 0;
		
		
		_attackingUnderlay = new FlxSprite(x, y);
		var sf : Float = 3;
		_attackingUnderlay.makeGraphic(Std.int(GameProperties.TileSize * sf), Std.int(GameProperties.TileSize * sf));
		var ofs : Float = -GameProperties.TileSize * 0.5 + GameProperties.TileSize * sf * 0.5;
		_attackingUnderlay.offset.set(ofs, ofs);
		_attackingUnderlay.alpha = 0;
    }

    //#################################################################

    public override function update(elapsed)
    {
		super.update(elapsed);
		_attackingUnderlay.setPosition(x, y);
		
		if (_attacking)
		{
			velocity.set();
			acceleration.set();
			immovable = true;
		}
		else
		{
			
			immovable = false;
			_idleTimer -= elapsed;
			AttackTimer -= elapsed;
			
			if (_idleTimer <= 0)
			{
				doMovement();
				
				
				if (_distanceToPlayer <= GameProperties.TileSize * 1.3)
				{
					Attack();	
				}
			}
			
			
		}
        
    }
	
	function Attack() 
	{
		if (!_attacking)
		{
			if (AttackTimer <= 0)
			{
				_attacking = true;
				_attackingUnderlay.alive = true;
				
				var t : FlxTimer = new FlxTimer();
				t.start(GameProperties.EnemyAttackingTime, function(t: FlxTimer) 
				{
					_attacking = false; 
					_idleTimer = 0.2;  
					AttackTimer = GameProperties.EnemyAttackTimerMax;
					this.velocity.set();
					this.acceleration.set();
					_attackingUnderlay.alpha = 1.0;
					FlxTween.tween(_attackingUnderlay, { alpha:0.0 }, 0.2);
				});
				
				FlxTween.tween(_attackingUnderlay, { alpha:0.5 }, GameProperties.EnemyAttackingTime*0.9);
			}
		}
	}

    //#################################################################

    public function hit(damage: Float, px:Float, py:Float)
    {
        CurrentHealth -= damage;
        trace(CurrentHealth);
		
		// calculate pushback
		var dir : FlxVector = new FlxVector (x -px, y - py);
		dir = dir.normalize();
		
		this.velocity.set(dir.x * 350, dir.y * 350);
		_idleTimer = 0.35;
		

        if(CurrentHealth <= 0.0)
        {
            alive = false;
			trace('I am dead');
			_playState.level.spawnCoins(this);
        }
    }

    //#################################################################

    function doMovement()
    {
        var playerVector = new FlxVector(_playState.player.x, _playState.player.y);
        var enemyVector = new FlxVector(x, y);
		
		_distanceToPlayer = playerVector.dist(enemyVector);

        if(_distanceToPlayer <= Aggressivity * GameProperties.TileSize)
        {
            if(_distanceToPlayer > GameProperties.TileSize)
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

	public function drawUnderlay()
	{
		_attackingUnderlay.draw();
	}
	
    public override function draw()
    {
        super.draw();
    }


    //#################################################################
}