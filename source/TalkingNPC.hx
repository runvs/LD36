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
        'I\'ve heard here\nare many treasures!',
		'When you die,\nyou loose your items.',
		'Do you also have\na map in your inventory?',
		'Try dashing out of the warrior\'s attacks',
		'Abilities from the Trainer are permanent.',
		'Visit the Healer!\nHe saved me lots of times.',
		'Agility decreases\nthe dash cooldown.',
		'Strength makes your attacks more powerful',
		'Healing prices increase\every time you heal.',
		'Warriors drop precious coins!'
    ];

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

		loadGraphic(AssetPaths.Talker__png, true, 16, 16);

        _announceTimer = new FlxTimer();
        _announceTimer.start(GameProperties.NPCAnnounceTime, onAnnounceTimer, 0);
        
        _announceText = new FlxText(x - 64, y - GameProperties.TileSize, 0, getRandomText());
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

    public override function handleInput(player: Player)
    {
        super.handleInput(player);
        _player.stopNpcInteraction();
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