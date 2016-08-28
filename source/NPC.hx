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

    public function interact()
    {
        trace('Player interaction');
    }

    //#################################################################
}