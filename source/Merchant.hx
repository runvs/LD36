package;

import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;

class Merchant extends NPC
{
    //#################################################################

    var _player : Player;

    var _newWaresTimer   : FlxTimer;
    var _newWaresText    : FlxText;
    var _newWaresTimeout : Float;
    var _newWaresBar     : HudBar;

    var _inventory       : FlxSprite;
    var _inventoryBorder : FlxSprite;
    var _items           : Array<Item>;
    var _showInventory   : Bool;

    var _listBackground   : FlxSprite;
    var _listSelection    : FlxSprite;
    var _itemTexts        : FlxTypedGroup<FlxText>;
    var _currentSelection : Int;
    var _inputDeadTime    : Float;
    var _closeButton      : FlxButton;
    var _coinsText        : FlxText;

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        _newWaresTimer = new FlxTimer();
        _newWaresTimer.start(GameProperties.MerchantNewWaresTime, onNewWaresTimer, 0);

        _newWaresText = new FlxText(x, y - GameProperties.TileSize, 0, 'New wares\neverybody!');
        _newWaresText.alignment = flixel.text.FlxTextAlign.CENTER;
        _newWaresTimeout = GameProperties.MerchantNewWaresTextTimeout;
        _newWaresBar = new HudBar(150, 190, 80, 15, false);

        loadGraphic(AssetPaths.Merchant__png, true, 16, 16);
		animation.add("idle", [0, 1, 2, 3], 4, true);
        animation.play("idle");
        _showInventory = false;

        _inventory = new FlxSprite(10, 10);
        _inventory.makeGraphic(FlxG.width - 20, 210, FlxColor.GRAY);
        _inventory.scrollFactor.set();

        _inventoryBorder = new FlxSprite(9, 9);
        _inventoryBorder.makeGraphic(cast(_inventory.width + 2, Int), cast(_inventory.height + 2, Int), FlxColor.BLACK);
        _inventoryBorder.scrollFactor.set();

        _items = recreateInventory();
        _listBackground = new FlxSprite(20, 20);
        _listBackground.makeGraphic(FlxG.width - 40, 160, FlxColor.WHITE);
        _listBackground.scrollFactor.set();

        _listSelection = new FlxSprite(20, 20);
        _listSelection.makeGraphic(FlxG.width - 40, 20, FlxColor.fromRGB(0, 0, 0, 64));
        _listSelection.scrollFactor.set();

        _closeButton = new FlxButton(0, 190, 'Close', onCloseClick);
        _closeButton.x = FlxG.width - 20 - _closeButton.width;
        _closeButton.scrollFactor.set();

        _coinsText   = new FlxText(20, 190, 0, 'Current coins: 0');
        _coinsText.scrollFactor.set();

        _currentSelection = 0;
        _inputDeadTime    = 0;
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);

        if(_newWaresTimeout > 0.0)
        {
            _newWaresTimeout -= elapsed;
        }

        _newWaresBar.health = 1 - _newWaresTimer.progress;
        _newWaresBar.update(elapsed);

        if(_player != null)
        {
            for(i in 0..._items.length)
            {
                if(_player.coins < _items[i].value)
                {
                    _itemTexts.members[i].color = GameProperties.MerchantColorUnavailable;
                }

                if(_items[i].sold)
                {
                    _itemTexts.members[i].color = GameProperties.MerchantColorSold;
                }
            }

            _coinsText.text = 'Current coins: ${_player.coins}';
        }

        _listSelection.update(elapsed);
        _closeButton.update(elapsed);
    }

    //#################################################################

    public override function draw()
    {
        super.draw();

        if(_newWaresTimeout > 0.0)
        {
            _newWaresText.draw();
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
            _listBackground.draw();
            _listSelection.draw();

            _closeButton.draw();
            _itemTexts.draw();
            _coinsText.draw();
            _newWaresBar.draw();
        }
    }

    //#################################################################

    public override function handleInput(player: Player)
    {
        if(_player == null) _player = player;
        super.handleInput(_player);

        if(MyInput.AttackButtonJustPressed)
        {
            if(_currentSelection == _items.length)
            {
                onCloseClick();
            }
            else
            {
                if(_items[_currentSelection].value <= _player.coins)
                {
                    _items[_currentSelection].sold = true;
                    
                    switch _items[_currentSelection].itemType
                    {
                        case ItemType.HEAD:
                            _player.headItem   = _items[_currentSelection];
                        case ItemType.TORSO:
                            _player.torsoItem  = _items[_currentSelection];
                        case ItemType.LEGS:
                            _player.legsItem   = _items[_currentSelection];
                        case ItemType.WEAPON:
                            _player.weaponItem = _items[_currentSelection];
                    }
                }
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
            if(vy > 0)
            {
                if(_currentSelection <= _items.length - 1)
                {
                    _currentSelection++;
                    _inputDeadTime += GameProperties.MerchantInputDeadTime;
                    
                    if(_currentSelection < _items.length)
                    {
                        _listSelection.y = 20 + 20 * _currentSelection;
                    }
                    else
                    {
                        _listSelection.makeGraphic(
                            cast(_closeButton.width + 4, Int),
                            cast(_closeButton.height + 4, Int),
                            FlxColor.fromRGB(0, 0, 0, 64)
                        );

                        _listSelection.x = _closeButton.x - 2;
                        _listSelection.y = _closeButton.y - 2;
                    }
                }
            }
            else if(vy < 0)
            {
                if(_currentSelection > 0)
                {
                    if(_currentSelection == _items.length)
                    {
                        _listSelection.x = 20;
                        _listSelection.makeGraphic(FlxG.width - 40, 20, FlxColor.fromRGB(0, 0, 0, 64));
                    }

                    _currentSelection--;
                    _inputDeadTime += GameProperties.MerchantInputDeadTime;
                    _listSelection.y = 20 + 20 * _currentSelection;
                }
            }
        }

        // TODO fix this tween
        //FlxTween.tween(_listSelection, { y: 20 + 20 * _currentSelection }, GameProperties.MerchantInputDeadTime);
    }

    //#################################################################

    function onNewWaresTimer(timer : FlxTimer)
    {
        _newWaresTimeout = GameProperties.MerchantNewWaresTextTimeout;
        _items = recreateInventory();
    }

    //#################################################################

    function onCloseClick()
    {
        _showInventory = false;
        _player.stopNpcInteraction();
    }

    //#################################################################

    function recreateInventory() : Array<Item>
    {
        _itemTexts = new FlxTypedGroup(8);

        var items = [
            Item.createRandom(ItemType.HEAD),
            Item.createRandom(ItemType.HEAD),

            Item.createRandom(ItemType.TORSO),
            Item.createRandom(ItemType.TORSO),

            Item.createRandom(ItemType.LEGS),
            Item.createRandom(ItemType.LEGS),

            Item.createRandom(ItemType.WEAPON),
            Item.createRandom(ItemType.WEAPON)
        ];

        for(i in 0...items.length)
        {
            var text = new FlxText(25, 20 * (i + 1), 0, items[i].toString());
            text.color = GameProperties.MerchantColorAvailable;
            text.scrollFactor.set();

            _itemTexts.add(text);
        }

        return items;
    }

    //#################################################################

    public override function interact()
    {
        super.interact();

        _showInventory = true;

        _currentSelection = 0;
        _listSelection.x = 20;
        _listSelection.makeGraphic(FlxG.width - 40, 20, FlxColor.fromRGB(0, 0, 0, 64));
        _listSelection.y = 20 + 20 * _currentSelection;
    }

    // ################################################################
}