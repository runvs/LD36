package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;

class Inventory extends FlxSprite
{
    //#################################################################

    var _player : Player;

    var _headItemText   : FlxText;
    var _torsoItemText  : FlxText;
    var _legsItemText   : FlxText;
    var _weaponItemText : FlxText;

    //#################################################################

    public function new(player : Player)
    {
        super();

        _player = player;

        _headItemText   = new FlxText(20, 20, 0, '');
        _torsoItemText  = new FlxText(20, 40, 0, '');
        _legsItemText   = new FlxText(20, 60, 0, '');
        _weaponItemText = new FlxText(20, 80, 0, '');

        makeGraphic(FlxG.width - 20, FlxG.height - 20, flixel.util.FlxColor.GRAY);
        scrollFactor.set();
        setPosition(10, 10);
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);

        if(_player.headItem != null)
        {
            _headItemText.text = "Head: " + _player.headItem.toString();
        }

        if(_player.torsoItem != null)
        {
            _torsoItemText.text = "Torso: " + _player.torsoItem.toString();
        }

        if(_player.legsItem != null)
        {
            _legsItemText.text = "Legs: " + _player.legsItem.toString();
        }

        if(_player.weaponItem != null)
        {
            _weaponItemText.text = "Weapon: " + _player.weaponItem.toString();
        }
    }

    //#################################################################

    public override function draw()
    {
        super.draw();

        if(_player.headItem != null)
        {
            _headItemText.draw();
        }

        if(_player.torsoItem != null)
        {
            _torsoItemText.draw();
        }

        if(_player.legsItem != null)
        {
            _legsItemText.draw();
        }

        if(_player.weaponItem != null)
        {
            _weaponItemText.draw();
        }
    }

    //#################################################################
}