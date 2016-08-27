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

	var _hitArea      : FlxSprite;
	var _facing       : Facing;

    //#################################################################

    public function new(playState: PlayState)
    {
        super();

        makeGraphic(16, 16, flixel.util.FlxColor.ORANGE);

		_hitArea = new FlxSprite();
		_hitArea.makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 255, 255, 64));
		_facing = Facing.EAST;

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

		switch _facing
		{
			case Facing.EAST:
				_hitArea.setPosition(x + GameProperties.TileSize, y);
			case Facing.WEST:
				_hitArea.setPosition(x - GameProperties.TileSize, y);
			case Facing.NORTH:
				_hitArea.setPosition(x, y - GameProperties.TileSize);
			case Facing.SOUTH:
				_hitArea.setPosition(x, y + GameProperties.TileSize);
			
			case Facing.NORTHEAST:
				_hitArea.setPosition(x + GameProperties.TileSize / 2, y - GameProperties.TileSize / 2);
			case Facing.NORTHWEST:
				_hitArea.setPosition(x - GameProperties.TileSize / 2, y - GameProperties.TileSize / 2);
			case Facing.SOUTHEAST:
				_hitArea.setPosition(x + GameProperties.TileSize / 2, y + GameProperties.TileSize / 2);
			case Facing.SOUTHWEST:
				_hitArea.setPosition(x - GameProperties.TileSize / 2, y + GameProperties.TileSize / 2);
		}

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

			if(vx > 0)
			{
				_facing = Facing.EAST;
				if(vy > 0) _facing = Facing.SOUTHEAST;
				if(vy < 0) _facing = Facing.NORTHEAST;
			}
			else if(vx < 0)
			{
				_facing = Facing.WEST;
				if(vy > 0) _facing = Facing.SOUTHWEST;
				if(vy < 0) _facing = Facing.NORTHWEST;
			}
			else
			{
				if(vy > 0) _facing = Facing.SOUTH;
				if(vy < 0) _facing = Facing.NORTH;
			}
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
		var stepSize = GameProperties.PlayerMovementMaxDashLength / GameProperties.TileSize / 2;
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

		_hitArea.draw();
	}

    //#################################################################
}