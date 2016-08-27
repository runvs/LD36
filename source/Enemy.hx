package;

import flixel.FlxSprite;

class Enemy extends FlxSprite
{
    //#################################################################

    public var AttackStrength : Float;
    public var MaxHealth      : Float;
    public var CurrentHealth  : Float;

    //#################################################################

    public function new(attackStrength: Float, maxHealth: Float)
    {
        super();

        this.AttackStrength = attackStrength;
        this.MaxHealth      = maxHealth;
        this.CurrentHealth  = maxHealth;

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