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

    var _statsCaptionText : FlxText;
    var _statsText        : FlxText;

    //#################################################################

    public function new(player : Player)
    {
        super();

        _player = player;

        _headItemText   = new FlxText(20, 20, 0, '');
        _torsoItemText  = new FlxText(20, 40, 0, '');
        _legsItemText   = new FlxText(20, 60, 0, '');
        _weaponItemText = new FlxText(20, 80, 0, '');

        _statsCaptionText = new FlxText(20, 140, 0, '');
        _statsText        = new FlxText(100, 140, 0, '');

        _headItemText.scrollFactor.set();
        _torsoItemText.scrollFactor.set();
        _legsItemText.scrollFactor.set();
        _weaponItemText.scrollFactor.set();

        _statsCaptionText.scrollFactor.set();
        _statsText.scrollFactor.set();

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
        else
        {
            _headItemText.text = "Head: empty";
        }

        if(_player.torsoItem != null)
        {
            _torsoItemText.text = "Torso: " + _player.torsoItem.toString();
        }
        else
        {
            _torsoItemText.text = "Torso: empty";
        }

        if(_player.legsItem != null)
        {
            _legsItemText.text = "Legs: " + _player.legsItem.toString();
        }
        else
        {
            _legsItemText.text = "Legs: empty";
        }

        if(_player.weaponItem != null)
        {
            _weaponItemText.text = "Weapon: " + _player.weaponItem.toString();
        }
        else
        {
            _weaponItemText.text = "Weapon: empty";
        }

        _statsCaptionText.text  = 'Health:\nStrength:\nAgility:';

        _statsText.text  = '${_player.health}/${_player.healthMax}\n';
        _statsText.text += '${_player.strength}\n';
        _statsText.text += '${_player.agility}';
    }

    //#################################################################

    public override function draw()
    {
        super.draw();

        _headItemText.draw();
        _torsoItemText.draw();
        _legsItemText.draw();
        _weaponItemText.draw();

        _statsCaptionText.draw();
        _statsText.draw();
    }

    //#################################################################
}