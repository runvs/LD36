package;

class Healer extends NPC
{
    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        makeGraphic(GameProperties.TileSize, GameProperties.TileSize, flixel.util.FlxColor.PURPLE);
    }

    //#################################################################

    public override function interact()
    {
        
    }

    //#################################################################
}