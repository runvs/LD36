package;

class Trainer extends NPC
{
    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

		loadGraphic(AssetPaths.trainer__png, true, 16, 16);
		animation.add("idle", [0, 1, 2, 3], 5, true);
		animation.play("idle");
    }

    //#################################################################

    public override function interact()
    {
        super.interact();
    }

    //#################################################################
}