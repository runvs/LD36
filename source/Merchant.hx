package;

import flixel.util.FlxTimer;
import flixel.text.FlxText;

class Merchant extends NPC
{
    //#################################################################

    var _newWaresTimer   : FlxTimer;
    var _newWaresText    : FlxText;
    var _newWaresTimeout : Float;

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        _newWaresTimer = new FlxTimer();
        _newWaresTimer.start(GameProperties.MerchantNewWaresTime, onNewWaresTimer, 0);

        _newWaresText = new FlxText(x, y - GameProperties.TileSize, 0, 'New wares everybody!');
        _newWaresTimeout = GameProperties.MerchantNewWaresTextTimeout;

        makeGraphic(GameProperties.TileSize, GameProperties.TileSize, flixel.util.FlxColor.CYAN);
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);

        if(_newWaresTimeout > 0.0)
        {
            _newWaresTimeout -= elapsed;
        }
    }

    //#################################################################

    public override function draw()
    {
        super.draw();

        if(_newWaresTimeout > 0.0)
        {
            _newWaresText.draw();
        }
    }

    //#################################################################

    function onNewWaresTimer(timer : FlxTimer)
    {
        _newWaresTimeout = GameProperties.MerchantNewWaresTextTimeout;
    }

    //#################################################################

    public override function interact()
    {
        
        super.interact();
    }

    // ################################################################
}