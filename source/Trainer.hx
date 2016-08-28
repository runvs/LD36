package;

class Trainer extends NPC
{
    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

		this.loadGraphic(AssetPaths.trainer__png, true, 16, 16);
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