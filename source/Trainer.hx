package;

class Trainer extends NPC
{
    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        makeGraphic(GameProperties.TileSize, GameProperties.TileSize, flixel.util.FlxColor.BROWN);
    }

    //#################################################################

    public override function interact()
    {
        super.interact();
    }

    //#################################################################
}