package;

import flixel.FlxSprite;

class Item {
    //#################################################################

    public var value  : Int;
    public var sprite : FlxSprite;
    public var name   : String;

    public var agilityBonus  : Float;
    public var strengthBonus : Float;
    public var healthBonus   : Float;

    var _itemType : ItemType;

    //#################################################################

    public function new(itemType : ItemType, name : String, agilityBonus : Float, strengthBonus : Float, healthBonus : Float)
    {
        _itemType = itemType;
        this.name = name;

        this.agilityBonus  = agilityBonus;
        this.strengthBonus = strengthBonus;
        this.healthBonus   = healthBonus;

        value = calculateValue();
    }

    //#################################################################

    function calculateValue() : Int
    {
        return cast(Math.round(agilityBonus + strengthBonus + healthBonus * Math.PI), Int);
    }

    //#################################################################

    public function toString() : String
    {
        return '$name\n    ${(agilityBonus >= 0 ? "+" : "-")}$agilityBonus Agi, ${(strengthBonus >= 0 ? "+" : "-")}$strengthBonus Str, ${(healthBonus >= 0 ? "+" : "-")}$healthBonus Health, Value: $value';
    }

    //#################################################################
}