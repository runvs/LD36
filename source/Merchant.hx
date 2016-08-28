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

    var _inventory     : FlxSprite;
    var _items         : Array<Item>;
    var _showInventory : Bool;

    var _listBackground   : FlxSprite;
    var _listSelection    : FlxSprite;
    var _itemTexts        : FlxTypedGroup<FlxText>;
    var _currentSelection : Int;
    var _inputDeadTime    : Float;
    var _closeButton      : FlxButton;

    //#################################################################

    public override function new(x : Int, y : Int)
    {
        super(x, y);

        _newWaresTimer = new FlxTimer();
        _newWaresTimer.start(GameProperties.MerchantNewWaresTime, onNewWaresTimer, 0);

        _newWaresText = new FlxText(x, y - GameProperties.TileSize, 0, 'New wares everybody!');
        _newWaresTimeout = GameProperties.MerchantNewWaresTextTimeout;

        makeGraphic(GameProperties.TileSize, GameProperties.TileSize, FlxColor.CYAN);

        _inventory = new FlxSprite(10, 10);
        _inventory.makeGraphic(FlxG.width - 20, FlxG.height - 20, FlxColor.GRAY);
        _inventory.scrollFactor.set();
        _showInventory = false;

        _items = recreateInventory();
        _listBackground = new FlxSprite(20, 20);
        _listBackground.makeGraphic(FlxG.width - 40, 165, FlxColor.WHITE);
        _listBackground.scrollFactor.set();

        _listSelection = new FlxSprite(20, 20);
        _listSelection.makeGraphic(FlxG.width - 40, 20, FlxColor.fromRGB(0, 0, 0, 64));
        _listSelection.scrollFactor.set();

        _closeButton = new FlxButton(20, FlxG.height - 40, 'Close', onCloseClick);

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
            _inventory.draw();
            _listBackground.draw();
            _listSelection.draw();

            _closeButton.draw();
            _itemTexts.draw();
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
            text.color = FlxColor.BLACK;
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
    }

    // ################################################################
}