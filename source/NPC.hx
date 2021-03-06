package;

import flixel.FlxSprite;

class NPC extends FlxSprite
{
    //#################################################################

    public var playerInRange : Bool;

    var _player : Player;

    //#################################################################
    
    public override function new(x : Int, y : Int)
    {
        super();

        setPosition(x, y);
		this.immovable = true;
        playerInRange = false;
    }

    //#################################################################

    public function drawHud()
    {

    }

    //#################################################################

    public function handleInput(player: Player)
    {
        if(_player == null) _player = player;
        _player.velocity.set();
        _player.acceleration.set();
    }

    //#################################################################

    public function interact()
    {
    }

    //#################################################################
}