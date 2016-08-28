package;

import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class Trainer extends NPC
{
    //#################################################################

    var _inventory       : FlxSprite;
    var _inventoryBorder : FlxSprite;
    var _btnSelection    : FlxSprite;

    var _strengthButton  : FlxButton;
    var _agilityButton   : FlxButton;
    var _healthButton    : FlxButton;

    var _closeButton     : FlxButton;
    var _strengthText    : FlxText;
    var _agilityText     : FlxText;
    var _healthText      : FlxText;
    var _coinsText       : FlxText;

    var _currentSelection : Int;
    var _inputDeadTime    : Float;
    var _showInventory    : Bool;
    
    var _announceText     : FlxText;
    var _announceTimeout  : Float;
    var _announceTimer    : FlxTimer;

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

		loadGraphic(AssetPaths.trainer__png, true, 16, 16);
		animation.add("idle", [0, 1, 2, 3], 5, true);
		animation.play("idle");

        _announceTimer = new FlxTimer();
        _announceTimer.start(GameProperties.NPCAnnounceTime, onAnnounceTimer, 0);
        
        _announceText = new FlxText(x, y - GameProperties.TileSize, 0, 'Improve your\nskills!');
        _announceText.alignment = flixel.text.FlxTextAlign.CENTER;
        _announceTimeout = GameProperties.NPCAnnounceTextTimeout;

        _inventory = new FlxSprite(10, 10);
        _inventory.makeGraphic(FlxG.width - 20, 210, FlxColor.GRAY);
        _inventory.scrollFactor.set();

        _inventoryBorder = new FlxSprite(9, 9);
        _inventoryBorder.makeGraphic(cast(_inventory.width + 2, Int), cast(_inventory.height + 2, Int), FlxColor.BLACK);
        _inventoryBorder.scrollFactor.set();

        _btnSelection = new FlxSprite(20, 20);
        _btnSelection.makeGraphic(FlxG.width - 40, 20, FlxColor.fromRGB(0, 0, 0, 64));
        _btnSelection.scrollFactor.set();

        _closeButton = new FlxButton(0, 190, 'Close', onCloseClick);
        _closeButton.x = FlxG.width - 20 - _closeButton.width;
        _closeButton.scrollFactor.set();

        _strengthText  = new FlxText(20, 20, 0, 'Current strength: 0\nUpgrade cost: 0');
        _strengthText.scrollFactor.set();
        _strengthButton = new FlxButton(20, 60, 'Strength +', onStrengthClick);
        _strengthButton.scrollFactor.set();

        _agilityText   = new FlxText(120, 20, 0, 'Current agility: 0\nUpgrade cost: 0');
        _agilityText.scrollFactor.set();
        _agilityButton = new FlxButton(120, 60, 'Agility +', onAgilityClick);
        _agilityButton.scrollFactor.set();

        _healthText   = new FlxText(220, 20, 0, 'Current health: 0\nUpgrade cost: 0');
        _healthText.scrollFactor.set();
        _healthButton = new FlxButton(220, 60, 'Health +', onHealthClick);
        _healthButton.scrollFactor.set();

        _coinsText    = new FlxText(20, 80, 0, 'Current coins: 0');
        _coinsText.scrollFactor.set();

        _currentSelection = 0;
        _inputDeadTime    = 0;
        _showInventory    = false;
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

        if(_player != null)
        {
            _coinsText.text = 'Current coins: ${_player.coins}';
            _strengthText.text = 'Current strength: ${_player.strength}\nUpgrade cost: ${getStrengthCosts()}';
            _agilityText.text = 'Current agility: ${_player.agility}\nUpgrade cost: ${getAgilityCosts()}';
            _healthText.text = 'Current health: ${_player.health}\nUpgrade cost: ${getHealthCosts()}';
            _healthText.text = 'Current health: ${GameProperties.roundForDisplay(_player.health)}\nUpgrade cost: ${getHealthCosts()}';

            if(_player.coins >= getStrengthCosts())
            {
                _strengthText.color = GameProperties.TrainerColorAvailable;
            }
            else
            {
                _strengthText.color = GameProperties.TrainerColorUnavailable;
            }

            if(_player.coins >= getAgilityCosts())
            {
                _agilityText.color = GameProperties.TrainerColorAvailable;
            }
            else
            {
                _agilityText.color = GameProperties.TrainerColorUnavailable;
            }

            if(_player.coins >= getHealthCosts())
            {
                _healthText.color = GameProperties.TrainerColorAvailable;
            }
            else
            {
                _healthText.color = GameProperties.TrainerColorUnavailable;
            }
        }
    }

    //#################################################################

    public override function handleInput(player: Player)
    {
        super.handleInput(player);

        if(MyInput.AttackButtonJustPressed)
        {
            if(_currentSelection == 0)      onStrengthClick();
            else if(_currentSelection == 1) onAgilityClick();
            else if(_currentSelection == 2) onHealthClick();
            else onCloseClick();
        }

        if(_inputDeadTime > 0.0)
        {
            _inputDeadTime -= FlxG.elapsed;
            return;
        }

        var vx : Float = MyInput.xVal * 500;
		var vy : Float = MyInput.yVal * 500;
		var l : Float = Math.sqrt(vx * vx + vy * vy);

		if (l >= 25)
		{
            if(vx > 0)
            {
                if(_currentSelection <= 3)
                {
                    var newX      : Float;
                    var newY      : Float;
                    var newWidth  : Int;
                    var newHeight : Int;

                    switch(_currentSelection)
                    {
                        default:
                            newX = newY = newWidth = newHeight = 0;
                        case 0:
                            newX      = _agilityButton.x - 2;
                            newY      = _agilityButton.y - 2;
                            newWidth  = cast(_agilityButton.width  + 4, Int);
                            newHeight = cast(_agilityButton.height + 4, Int);
                        case 1:
                            newX      = _healthButton.x - 2;
                            newY      = _healthButton.y - 2;
                            newWidth  = cast(_healthButton.width  + 4, Int);
                            newHeight = cast(_healthButton.height + 4, Int);
                        case 2:
                            newX      = _closeButton.x - 2;
                            newY      = _closeButton.y - 2;
                            newWidth  = cast(_closeButton.width  + 4, Int);
                            newHeight = cast(_closeButton.height + 4, Int);
                    }

                    _currentSelection++;
                    _inputDeadTime += GameProperties.MerchantInputDeadTime;
                    _btnSelection.x = newX;
                    _btnSelection.y = newY;
                    _btnSelection.makeGraphic(newWidth, newHeight, FlxColor.fromRGB(0, 0, 0, 64));
                }
            }
            else if(vx < 0)
            {
                if(_currentSelection > 0)
                {
                    var newX      : Float;
                    var newY      : Float;
                    var newWidth  : Int;
                    var newHeight : Int;

                    switch(_currentSelection)
                    {
                        default:
                            newX = newY = newWidth = newHeight = 0;
                        case 1:
                            newX      = _strengthButton.x - 2;
                            newY      = _strengthButton.y - 2;
                            newWidth  = cast(_strengthButton.width  + 4, Int);
                            newHeight = cast(_strengthButton.height + 4, Int);
                        case 2:
                            newX      = _agilityButton.x - 2;
                            newY      = _agilityButton.y - 2;
                            newWidth  = cast(_agilityButton.width  + 4, Int);
                            newHeight = cast(_agilityButton.height + 4, Int);
                        case 3:
                            newX      = _healthButton.x - 2;
                            newY      = _healthButton.y - 2;
                            newWidth  = cast(_healthButton.width  + 4, Int);
                            newHeight = cast(_healthButton.height + 4, Int);
                    }

                    _currentSelection--;
                    _inputDeadTime += GameProperties.MerchantInputDeadTime;
                    _btnSelection.x = newX;
                    _btnSelection.y = newY;
                    _btnSelection.makeGraphic(newWidth, newHeight, FlxColor.fromRGB(0, 0, 0, 64));
                }
            }
        }
    }

    //#################################################################

    public override function draw()
    {
        super.draw();

        if(_announceTimeout > 0.0)
        {
            _announceText.draw();
        }
    }

    //#################################################################

    public override function drawHud()
    {
        super.drawHud();

        if(_showInventory)
        {
            _inventoryBorder.draw();
            _inventory.draw();
            _btnSelection.draw();

            _strengthButton.draw();
            _strengthText.draw();
            _agilityButton.draw();
            _agilityText.draw();
            _healthButton.draw();
            _healthText.draw();

            _closeButton.draw();
            _coinsText.draw();
        }
    }

    //#################################################################

    public override function interact()
    {
        super.interact();

        if(!alive) return;

        _showInventory = true;

        _currentSelection = 0;
        _btnSelection.x = _strengthButton.x - 2;
        _btnSelection.y = _strengthButton.y - 2;
        
        _btnSelection.makeGraphic(
            cast(_strengthButton.width  + 4, Int),
            cast(_strengthButton.height + 4, Int),
            FlxColor.fromRGB(0, 0, 0, 64)
        );
    }

    //#################################################################

    function onAnnounceTimer(timer : FlxTimer)
    {
        _announceTimeout = GameProperties.NPCAnnounceTextTimeout;
    }

    //#################################################################

    function onCloseClick()
    {
        _showInventory = false;
        _player.stopNpcInteraction();
    }

    //#################################################################

    function onStrengthClick()
    {
        if(_player != null && _player.coins >= getStrengthCosts())
        {
            _player.coins -= getStrengthCosts();
            _player.strength += 1;
        }
    }

    //#################################################################

    function onAgilityClick()
    {
        if(_player != null && _player.coins >= getAgilityCosts())
        {
            _player.coins -= getAgilityCosts();
            _player.agility += 1;
        }
    }

    //#################################################################

    function onHealthClick()
    {
        if(_player != null && _player.coins >= getHealthCosts())
        {
            trace('Health click');

            _player.coins -= getHealthCosts();

            var ratio = _player.health / _player.healthMax;
            _player.healthBase += 1;
            _player.healthMax = GameProperties.PlayerHealthMaxDefault + _player.healthBase + _player.healthBonus;
            _player.health = _player.healthMax * ratio;
        }
    }

    //#################################################################

    function getStrengthCosts() : Int
    {
        if(_player != null)
        {
            var value = GameProperties.TrainerStrengthBaseCost + Math.pow(_player.strength, 0.8) * 7;

            return cast(Math.round(value), Int);
        }
        
        return 0;
    }

    //#################################################################

    function getAgilityCosts() : Int
    {
        if(_player != null)
        {
            var value = GameProperties.TrainerAgilityBaseCost + Math.pow(_player.agility, 0.8) * 8;

            return cast(Math.round(value), Int);
        }
        
        return 0;
    }

    //#################################################################

    function getHealthCosts() : Int
    {
        if(_player != null)
        {
            var value = GameProperties.TrainerHealthBaseCost + Math.pow(_player.health, 0.8) * 10;

            return cast(Math.round(value), Int);
        }

        return 0;
    }

    //#################################################################
}