package;

import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;

class Merchant extends NPC
{
    //#################################################################

    var _newWaresTimer   : FlxTimer;
    var _newWaresText    : FlxText;
    var _newWaresTimeout : Float;

    var _inventory     : FlxSprite;
    var _showInventory : Bool;

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        _newWaresTimer = new FlxTimer();
        _newWaresTimer.start(GameProperties.MerchantNewWaresTime, onNewWaresTimer, 0);

        _newWaresText = new FlxText(x, y - GameProperties.TileSize, 0, 'New wares everybody!');
        _newWaresTimeout = GameProperties.MerchantNewWaresTextTimeout;

        makeGraphic(GameProperties.TileSize, GameProperties.TileSize, flixel.util.FlxColor.CYAN);

        _inventory = new FlxSprite(10, 10);
        _inventory.makeGraphic(FlxG.width - 20, FlxG.height - 20, flixel.util.FlxColor.GRAY);
        _inventory.scrollFactor.set();
        _showInventory = false;
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

    public override function drawHud()
    {
        super.drawHud();

        if(_showInventory)
        {
            _inventory.draw();
        }
    }

    //#################################################################

    public override function handleInput(player: Player)
    {
        super.handleInput(player);

        if(MyInput.SpecialButtonJustPressed)
        {
            _showInventory = false;
            player.toggleNpcInteraction();
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

        _showInventory = true;
    }

    // ################################################################
}