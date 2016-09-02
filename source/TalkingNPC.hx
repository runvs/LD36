package;

import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class TalkingNPC extends NPC
{
    //#################################################################

    var _announceText     : FlxText;
    var _announceTimeout  : Float;
    var _announceTimer    : FlxTimer;
    var _announcements = [
        'I like talking',
        'Who are you?',
        'I\'ve heard here\nare many treasures!',
        'Are you here for the treasure, too?'
    ];

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

		makeGraphic(16, 16, FlxColor.PINK);

        _announceTimer = new FlxTimer();
        _announceTimer.start(GameProperties.NPCAnnounceTime, onAnnounceTimer, 0);
        
        _announceText = new FlxText(x, y - GameProperties.TileSize, 0, getRandomText());
        _announceText.alignment = flixel.text.FlxTextAlign.CENTER;
        _announceTimeout = GameProperties.NPCAnnounceTextTimeout;
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);

        if(!alive) return;

        if(_announceTimeout > 0.0)
        {
            _announceTimeout -= elapsed;
        }
    }

    //#################################################################

    public override function draw()
    {
        super.draw();

        if(_announceTimeout > 0.0 && alive && playerInRange)
        {
            _announceText.draw();
        }
    }

    //#################################################################

    function onAnnounceTimer(timer : FlxTimer)
    {
        _announceText.text = getRandomText();
        _announceTimeout   = GameProperties.NPCAnnounceTextTimeout;
    }

    //#################################################################

    function getRandomText() : String
    {
        var index = GameProperties.rng.int(0, _announcements.length - 1);
        return _announcements[index];
    }

    //#################################################################
}