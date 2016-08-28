package;

import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author 
 */
class UpcomingMessages extends FlxText
{
	var internalText:String;
	var messageIndex : Int;
	var updateTimer: Float;
	
	var finished : Bool;
	
	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) 
	{
		super(X, Y, FieldWidth, "", Size, EmbeddedFont);
		SetText(Text);

	}
	
	public function SetText (t:String)
	{
		internalText = t;
		StartNew();
	}
	
	public function StartNew()
	{
		messageIndex = 0;
		updateTimer = 0.125;
		this.text = "";
		finished = false;
	}
	
	public function getFinished() : Bool
	{
		return finished;
	}
	
	
	public function ShowAll()
	{
		this.text = internalText;
		messageIndex = internalText.length;
	}
	
	override public function update(elapsed):Void 
	{
		super.update(elapsed);
		updateTimer -= FlxG.elapsed;
		
		if (messageIndex < internalText.length)
		{
			if (updateTimer <= 0)
			{
				updateTimer = 0.035;
				this.text += internalText.charAt(messageIndex);
				messageIndex++;
			}
		}
		else
		{
			finished = true;
		}
		
	}
	
	
	
}