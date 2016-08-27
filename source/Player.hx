package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
    var _dashDir      : FlxPoint;
	var _dashWallTime : Float;
    var _accelFactor  : Float;

    //#################################################################

    public function new()
    {
        super();

        this.makeGraphic(16, 16, flixel.util.FlxColor.ORANGE);

		_accelFactor = GameProperties.PlayerMovementAcceleration;
		this.drag = GameProperties.PlayerMovementDrag;
		this.maxVelocity = GameProperties.PlayerMovementMaxVelocity;
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
		
		if (_dashWallTime <= 0)
		{
			if (MyInput.DashButtonJustPressed)
			{
				this.setPosition(x + _dashDir.x * 100, y + _dashDir.y * 100);
				_dashWallTime = 0.25;
				this.velocity.set(this.velocity.x/2, this.velocity.y/2);
			}
		}
		else
		{
			_dashWallTime -= FlxG.elapsed;
		}
    }

    //#################################################################
	
	public override function draw() 
	{
		super.draw();
		//dustparticles.draw();
	}

    //#################################################################
}