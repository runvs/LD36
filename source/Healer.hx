package;

import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class Healer extends NPC
{
    //#################################################################

    var _inventory       : FlxSprite;
    var _inventoryBorder : FlxSprite;
    var _btnSelection    : FlxSprite;

    var _healButton      : FlxButton;
    var _closeButton     : FlxButton;
    var _healText        : FlxText;
    var _coinsText       : FlxText;

    var _currentSelection : Int;
    var _inputDeadTime    : Float;
    var _showInventory    : Bool;

    var _announceText     : FlxText;
    var _announceTimeout  : Float;
    var _announceTimer    : FlxTimer;

    var _numberOfHeals : Int;

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

		loadGraphic(AssetPaths.healer__png, true, 16, 16);
		animation.add("idle", [0, 1, 2, 3], 5, true);
        animation.play("idle");

        _announceTimer = new FlxTimer();
        _announceTimer.start(GameProperties.NPCAnnounceTime, onAnnounceTimer, 0);
        
        _announceText = new FlxText(x, y - GameProperties.TileSize, 0, 'I can heal you!');
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

        _healButton = new FlxButton(20, 190, 'Heal', onHealClick);
        _healButton.scrollFactor.set();

        _healText = new FlxText(20, 40, 0, 'Healing costs: ${getHealCosts()}');
        _healText.scrollFactor.set();

        _coinsText   = new FlxText(20, 20, 0, 'Current coins: 0');
        _coinsText.scrollFactor.set();

        _currentSelection = 0;
        _inputDeadTime    = 0;
        _showInventory    = false;
        _numberOfHeals    = 0;
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

            if(_player.coins >= getHealCosts())
            {
                _healText.color = GameProperties.HealerColorAvailable;
            }
            else
            {
                _healText.color = GameProperties.HealerColorUnavailable;
            }
        }
    }

    //#################################################################

    public override function handleInput(player: Player)
    {
        super.handleInput(player);

        if(MyInput.AttackButtonJustPressed)
        {
            if(_currentSelection == 0)
            {
                onHealClick();
            }
            else
            {
                onCloseClick();
            }
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
                if(_currentSelection == 0)
                {
                    _currentSelection++;
                    _inputDeadTime += GameProperties.MerchantInputDeadTime;

                    _btnSelection.x = _closeButton.x - 2;
                    _btnSelection.y = _closeButton.y - 2;
                    
                    _btnSelection.makeGraphic(
                        cast(_closeButton.width + 4, Int),
                        cast(_closeButton.height + 4, Int),
                        FlxColor.fromRGB(0, 0, 0, 64)
                    );
                }
            }
            else if(vx < 0)
            {
                if(_currentSelection == 1)
                {
                    _currentSelection--;
                    _inputDeadTime += GameProperties.MerchantInputDeadTime;

                    _btnSelection.x = _healButton.x - 2;
                    _btnSelection.y = _healButton.y - 2;
                    
                    _btnSelection.makeGraphic(
                        cast(_healButton.width  + 4, Int),
                        cast(_healButton.height + 4, Int),
                        FlxColor.fromRGB(0, 0, 0, 64)
                    );
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

            _closeButton.draw();
            _healButton.draw();
            _coinsText.draw();
            _healText.draw();
        }
    }

    //#################################################################

    public override function interact()
    {
        super.interact();

        _showInventory = true;

        _currentSelection = 0;
        _btnSelection.x = _healButton.x - 2;
        _btnSelection.y = _healButton.y - 2;
        
        _btnSelection.makeGraphic(
            cast(_healButton.width  + 4, Int),
            cast(_healButton.height + 4, Int),
            FlxColor.fromRGB(0, 0, 0, 64)
        );
    }

    //#################################################################

    function onAnnounceTimer(timer : FlxTimer)
    {
        _announceTimeout = GameProperties.NPCAnnounceTextTimeout;
    }

    //#################################################################

    function getHealCosts() : Int
    {
        return GameProperties.HealerBaseCosts + cast(Math.pow(_numberOfHeals, 0.25), Int);
    }

    //#################################################################

    function onHealClick()
    {
        if(_player.coins >= getHealCosts() && _player.health != 1.0)
        {
            _player.health += _player.healthMax;
            
            _player.coins -= getHealCosts();
            _numberOfHeals++;
        }
    }

    //#################################################################

    function onCloseClick()
    {
        _showInventory = false;
        _player.stopNpcInteraction();
    }

    //#################################################################
}