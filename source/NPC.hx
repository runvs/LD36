package;

import flixel.FlxSprite;

class NPC extends FlxSprite
{
    //#################################################################
    
    public override function new(x : Int, y : Int)
    {
        super();

        setPosition(x, y);
    }

    //#################################################################

    public function drawHud()
    {

    }

    //#################################################################

    public function handleInput(player: Player)
    {
        player.velocity.set();
        player.acceleration.set();
    }

    //#################################################################

    public function interact()
    {
        trace('Player interaction');
    }

    //#################################################################
}