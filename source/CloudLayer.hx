package;

import flixel.FlxObject;
import flixel.FlxSprite;

class CloudLayer extends FlxObject
{
    //#################################################################

    var _layer1      : FlxSprite;
    var _layer2      : FlxSprite;
    var _layer3      : FlxSprite;

    var _timeout = 0.0;

    //#################################################################

    public override function new()
    {
        super();

        var speedX = -4;
        var speedY = -5;

        _layer1 = new FlxSprite(AssetPaths.clouds1__png);
        _layer1.alpha = 0.4;
        _layer1.velocity.set(speedX * 1, speedY * 1);

        _layer2 = new FlxSprite(AssetPaths.clouds2__png);
        _layer2.alpha = 0.4;
        _layer2.velocity.set(speedX * 2, speedY * 2);

        _layer3 = new FlxSprite(AssetPaths.clouds3__png);
        _layer3.alpha = 0.4;
        _layer3.velocity.set(speedX * 3, speedY * 3);
    }

    //#################################################################

    public override function update(elapsed)
    {
        super.update(elapsed);

        _layer1.update(elapsed);
        _layer2.update(elapsed);
        _layer3.update(elapsed);

        if(_layer1.x <= -_layer1.width && _layer1.y <= -_layer1.height)
        {
            _layer1.setPosition(_layer1.width / 2, _layer1.height / 2);
        }

        if(_layer2.x <= -_layer2.width && _layer2.y <= -_layer2.height)
        {
            _layer2.setPosition(_layer2.width / 2, _layer2.height / 2);
        }

        if(_layer3.x <= -_layer3.width && _layer3.y <= -_layer3.height)
        {
            _layer3.setPosition(_layer3.width / 2, _layer3.height / 2);
        }

        if(_timeout <= 0)
        {
            trace('${_layer1.x},${_layer1.y} ${_layer2.x},${_layer2.y} ${_layer3.x},${_layer3.y}');
            _timeout = 5.0;
        }

        _timeout -= elapsed;
    }

    //#################################################################

    public override function draw()
    {
        _layer1.draw();
        _layer2.draw();
        _layer3.draw();
    }

    //#################################################################
}