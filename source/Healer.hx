package;

class Healer extends NPC
{
    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        //makeGraphic(GameProperties.TileSize, GameProperties.TileSize, flixel.util.FlxColor.PURPLE);
		this.loadGraphic(AssetPaths.healer__png, true, 16, 16);
		this.animation.add("idle", [0, 1, 2, 3], 5, true);
		this.animation.play("idle");
    }

    //#################################################################

    public override function interact()
    {
        super.interact();
    }

    //#################################################################
}