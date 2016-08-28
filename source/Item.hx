package;

import flixel.FlxSprite;
import sys.io.File;
import haxe.Json;

class Item {
    //#################################################################

    public var value  : Int;
    public var sprite : FlxSprite;
    public var name   : String;

    public var agilityBonus  : Float;
    public var strengthBonus : Float;
    public var healthBonus   : Float;

    public var itemType : ItemType;

    static var json : ItemData;

    //#################################################################

    public function new(itemType : ItemType, name : String, agilityBonus : Float, strengthBonus : Float, healthBonus : Float)
    {
        this.itemType = itemType;
        this.name = name;

        this.agilityBonus  = agilityBonus;
        this.strengthBonus = strengthBonus;
        this.healthBonus   = healthBonus;

        value = calculateValue();
    }

    //#################################################################

    function calculateValue() : Int
    {
        return cast(Math.abs(Math.round(agilityBonus + strengthBonus + healthBonus * Math.PI)), Int);
    }

    //#################################################################

    public function toString() : String
    {
        return '$name\n    ${(agilityBonus >= 0 ? "+" : "")}$agilityBonus Agi, ${(strengthBonus >= 0 ? "+" : "")}$strengthBonus Str, ${(healthBonus >= 0 ? "+" : "")}$healthBonus Health, Value: $value';
    }

    //#################################################################

    public static function createRandom(?itemType : ItemType) : Item
    {
        if(itemType == null)
        {
            var selection = [ItemType.HEAD, ItemType.TORSO, ItemType.LEGS, ItemType.WEAPON];
            itemType = GameProperties.rng.getObject(selection);
        }

        if(json == null)
        {
            json = Json.parse(File.getContent(AssetPaths.items__json));
        }
        
        var baseName : String;
        switch(itemType)
        {
            case ItemType.HEAD:
                baseName = GameProperties.rng.getObject(json.baseNames.head);
            case ItemType.TORSO:
                baseName = GameProperties.rng.getObject(json.baseNames.torso);
            case ItemType.LEGS:
                baseName = GameProperties.rng.getObject(json.baseNames.legs);
            case ItemType.WEAPON:
                baseName = GameProperties.rng.getObject(json.baseNames.weapon);
        }

        var randomIndex = GameProperties.rng.int(0, json.prefixes.length - 1);
        var prefix = json.prefixes[randomIndex];

        randomIndex = GameProperties.rng.int(0, json.suffixes.length - 1);
        var suffix = json.suffixes[randomIndex];

        var strBonus  = prefix.strengthBonus + suffix.strengthBonus;
        var agiBonus  = prefix.agilityBonus  + suffix.agilityBonus;
        var hlthBonus = prefix.healthBonus   + suffix.healthBonus;

        return new Item(
            itemType,
            StringTools.trim('${prefix.name} $baseName ${suffix.name}'),
            strBonus,
            agiBonus,
            hlthBonus
        );
    }

    //#################################################################
}

typedef Affix = {
    var name          : String;
    var strengthBonus : Float;
    var agilityBonus  : Float;
    var healthBonus   : Float;
}

typedef BaseName = {
    var head  : Array<String>;
    var torso  : Array<String>;
    var legs   : Array<String>;
    var weapon : Array<String>;
}

typedef ItemData = {
    var prefixes : Array<Affix>;
    var suffixes : Array<Affix>;
    var baseNames: BaseName;
}