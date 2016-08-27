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

    public function new(itemType : ItemType, name : String)
    {
        _itemType = itemType;

        switch(itemType)
        {
            case ItemType.HEAD:

            case ItemType.TORSO:
            case ItemType.LEGS:
            case ItemType.WEAPON:
        }

        value = calculateValue();
    }

    //#################################################################

    function calculateValue() : Int
    {
        return cast(Math.round(agilityBonus + strengthBonus + healthBonus * Math.PI), Int);
    }

    //#################################################################
}