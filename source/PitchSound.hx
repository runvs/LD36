package;
import flixel.FlxG;
import flixel.system.FlxSound;

/**
 * ...
 * @author 
 */
class PitchSound
{
	var _snd : FlxSound;
	
	public var pitchMin : Float = 0.5;
	public var pitchMax : Float = 1.5;
	public var pitchDelta : Float = 0.1;
	
	// true if sound should go up, false if down
	public var pitchIncrease : Bool = true;
	
	var pitchChangeTimer : Float  = 0;
	public var pitchChangeTimerMax : Float  = 0.75;
	
	var pitch : Float;

	public function new(path:Dynamic, vol:Float = 1, loop, Bool = false) 
	{
		_snd = FlxG.sound.load(path, vol, loop);
	}
	
	public function update (elapsed : Float )
	{
		//trace("pitch update");
		if (pitchChangeTimer >= 0)
		{
			pitchChangeTimer -= elapsed;
		}
		else
		{
			//trace("pitch " + pitch);
			if (pitchIncrease)
			{
				pitch = pitchMin;
			}
			else 
			{
				pitch = pitchMax;
			}
		}
	}
	
	public function play()
	{
		if (pitchChangeTimer >= 0)
		{
			if (pitchIncrease)
				pitch += pitchDelta;
			else
				pitch -= pitchDelta;
			
			if (pitch >= pitchMax) pitch = pitchMax;
			if (pitch <= pitchMin) pitch = pitchMin;
		}
		_snd.pitch = pitch;
		_snd.play();
		pitchChangeTimer = pitchChangeTimerMax;
	}
}