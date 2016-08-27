package;

import flixel.FlxSprite;

class Enemy extends FlxSprite
{
    //#################################################################

    public function new()
    {
        super();

        this.makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 0, 255));

        this.setPosition(128, 32);
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);
    }

    //#################################################################

    public override function draw()
    {
        super.draw();
    }

    //#################################################################
}