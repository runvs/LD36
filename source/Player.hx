package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
    //#################################################################

    var _dashDir      : FlxPoint;
	var _dashCooldown : Float;
    var _accelFactor  : Float;

	var _playState    : PlayState;

    //#################################################################

    public function new(playState: PlayState)
    {
        super();

        makeGraphic(16, 16, flixel.util.FlxColor.ORANGE);

		_accelFactor = GameProperties.PlayerMovementAcceleration;
		drag         = GameProperties.PlayerMovementDrag;
		maxVelocity  = GameProperties.PlayerMovementMaxVelocity;

        _dashCooldown = 0;
        _dashDir = new FlxPoint();

		_playState = playState;
        this.setPosition(8*16, 3*16);
    }

    //#################################################################

    public override function update(elapsed: Float)
    {
        super.update(elapsed);

        handleInput();
    }

    //#################################################################

    function handleInput()
    {
        var vx : Float = MyInput.xVal * _accelFactor;
		var vy : Float = MyInput.yVal * _accelFactor;
		var l : Float = Math.sqrt(vx * vx + vy * vy);

		if (l >= 25)
		{
			_dashDir.set(vx / l, vy / l);
		}
		this.acceleration.set(vx, vy);
		
		if (_dashCooldown <= 0)
		{
			if (MyInput.DashButtonJustPressed)
			{
				dash();
				_dashCooldown = GameProperties.PlayerMovementDashCooldown;
				this.velocity.set(this.velocity.x/2, this.velocity.y/2);
			}
		}
		else
		{
			_dashCooldown -= FlxG.elapsed;
		}
    }

    //#################################################################

	function dash()
	{
		var stepSize = GameProperties.PlayerMovementMaxDashLength / GameProperties.TileSize / 4;
		var currentStep = 0.0;
		var lastPosition : FlxPoint;

		while(currentStep < GameProperties.PlayerMovementMaxDashLength)
		{
			lastPosition = getPosition();

			setPosition(x + _dashDir.x * stepSize, y + _dashDir.y * stepSize);

			if(FlxG.overlap(this, _playState.level.collisionMap))
			{
				setPosition(lastPosition.x, lastPosition.y);
				break;
			}

			currentStep += stepSize;
		}
	}

    //#################################################################
	
	public override function draw() 
	{
		super.draw();
	}

    //#################################################################
}