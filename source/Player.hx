package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class Player extends FlxSprite
{
    //#################################################################

    var _dashDir        : FlxPoint;
	var _dashCooldown   : Float;
    var _accelFactor    : Float;

	var _playState      : PlayState;

	var _hitArea        : FlxSprite;
	var _facing         : Facing;
	var _attackCooldown : Float;
	
	var _coins			: Int ;
	var _coinsText 		: FlxText;
	
	var _healthBar 		: HudBar;
	var _healthMax: Float;

	var _headItem       : Item;
	var _torsoItem      : Item;
	var _legsItem       : Item;
	var _weaponItem     : Item;

	var _agility        : Float;

    //#################################################################

    public function new(playState: PlayState)
    {
        super();

        makeGraphic(16, 16, flixel.util.FlxColor.ORANGE);

		_hitArea = new FlxSprite();
		_hitArea.makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 255, 255, 64));
		_facing = Facing.EAST;
		_attackCooldown = 0.0;

		_accelFactor = GameProperties.PlayerMovementAcceleration;
		drag         = GameProperties.PlayerMovementDrag;
		maxVelocity  = GameProperties.PlayerMovementMaxVelocity;

        _dashCooldown = 0;
        _dashDir = new FlxPoint();
		
		_coins = 0;
		_weaponItem = new Item(ItemType.WEAPON, 'Mighty Longsword of Mutilation');

		_playState = playState;

		setPosition(8 * GameProperties.TileSize, 2 * GameProperties.TileSize);
		
		health = _healthMax = GameProperties.PlayerHealthMaxDefault;
		_healthBar = new HudBar(10, 10, 96, 16, false);
		
		_coinsText = new FlxText(128, 10, 0, "", 12);
		_coinsText.scrollFactor.set();
    }

    //#################################################################

    public override function update(elapsed: Float)
    {
        super.update(elapsed);

		switch _facing
		{
			case Facing.EAST:
				_hitArea.setPosition(x + GameProperties.TileSize, y);
			case Facing.WEST:
				_hitArea.setPosition(x - GameProperties.TileSize, y);
			case Facing.NORTH:
				_hitArea.setPosition(x, y - GameProperties.TileSize);
			case Facing.SOUTH:
				_hitArea.setPosition(x, y + GameProperties.TileSize);
			
			case Facing.NORTHEAST:
				_hitArea.setPosition(x + GameProperties.TileSize / 2, y - GameProperties.TileSize / 2);
			case Facing.NORTHWEST:
				_hitArea.setPosition(x - GameProperties.TileSize / 2, y - GameProperties.TileSize / 2);
			case Facing.SOUTHEAST:
				_hitArea.setPosition(x + GameProperties.TileSize / 2, y + GameProperties.TileSize / 2);
			case Facing.SOUTHWEST:
				_hitArea.setPosition(x - GameProperties.TileSize / 2, y + GameProperties.TileSize / 2);
		}

        handleInput();
		
		
		_healthBar.health = health/_healthMax;
		_healthBar.update(elapsed);
		_coinsText.text = Std.string(_coins);
		_coinsText.update(elapsed);
    }

    //#################################################################

    function handleInput()
    {
        var vx : Float = MyInput.xVal * _accelFactor;
		var vy : Float = MyInput.yVal * _accelFactor;
		var l : Float = Math.sqrt(vx * vx + vy * vy);

		if (l >= 25)
		{
			_dashDir.set(vx / l, vy / l);

			if(vx > 0)
			{
				_facing = Facing.EAST;
				if(vy > 0) _facing = Facing.SOUTHEAST;
				if(vy < 0) _facing = Facing.NORTHEAST;
			}
			else if(vx < 0)
			{
				_facing = Facing.WEST;
				if(vy > 0) _facing = Facing.SOUTHWEST;
				if(vy < 0) _facing = Facing.NORTHWEST;
			}
			else
			{
				if(vy > 0) _facing = Facing.SOUTH;
				if(vy < 0) _facing = Facing.NORTH;
			}
		}
		this.acceleration.set(vx, vy);
		
		if (_dashCooldown <= 0)
		{
			if (MyInput.DashButtonJustPressed)
			{
				dash();
				_dashCooldown = GameProperties.PlayerMovementDashCooldown;
				this.velocity.set(this.velocity.x/2, this.velocity.y/2);
			}
		}
		else
		{
			_dashCooldown -= FlxG.elapsed;
		}
		
		_attackCooldown -= FlxG.elapsed;
		if(_attackCooldown <= 0.0)
		{
			if(MyInput.AttackButtonJustPressed) attack();
		}
		else
		{
			
		}

		if(MyInput.InventoryButtonJustPressed)
		{
			showInventory();
		}
    }

    //#################################################################

	function showInventory()
	{

	}

    //#################################################################

	function recalculateBonuses()
	{
		var agilityBonus  = 0.0;
		var strengthBonus = 0.0;
		var healthBonus   = 0.0;

		if(_headItem != null)
		{
			agilityBonus  += _headItem.agilityBonus;
			strengthBonus += _headItem.strengthBonus;
			healthBonus   += _headItem.healthBonus;
		}

		if(_torsoItem != null)
		{
			agilityBonus  += _torsoItem.agilityBonus;
			strengthBonus += _torsoItem.strengthBonus;
			healthBonus   += _torsoItem.healthBonus;
		}

		if(_legsItem != null)
		{
			agilityBonus  += _legsItem.agilityBonus;
			strengthBonus += _legsItem.strengthBonus;
			healthBonus   += _legsItem.healthBonus;
		}

		if(_weaponItem != null)
		{
			agilityBonus  += _weaponItem.agilityBonus;
			strengthBonus += _weaponItem.strengthBonus;
			healthBonus   += _weaponItem.healthBonus;
		}
	}

    //#################################################################

	function attack()
	{
		_attackCooldown += GameProperties.PlayerAttackCooldown;
		for(enemy in _playState.level.enemies)
		{
			if(FlxG.overlap(this._hitArea, enemy))
			{
				enemy.hit(GameProperties.PlayerAttackBaseDamage, this.x, this.y);
			}
		}
	}

    //#################################################################

	function dash()
	{
		var stepSize = GameProperties.PlayerMovementMaxDashLength / GameProperties.TileSize / 2;
		var currentStep = 0.0;
		var lastPosition : FlxPoint;

		while(currentStep < GameProperties.PlayerMovementMaxDashLength)
		{
			lastPosition = getPosition();

			setPosition(x + _dashDir.x * stepSize, y + _dashDir.y * stepSize);

			if(FlxG.overlap(this, _playState.level.collisionMap))
			{
				setPosition(lastPosition.x, lastPosition.y);
				break;
			}

			currentStep += stepSize;
		}
	}

    //#################################################################
	
	public override function draw() 
	{
		super.draw();

		_hitArea.draw();
	}

	public function drawHud()
	{
		_healthBar.draw();
		_coinsText.draw();
		
	}
	
	public function pickUpCoins() 
	{
		_coins += 1;
	}
	
	public function takeDamage(d:Float)
	{
		health -= d;
		if (health <= 0)
		{
			alive = false;
		}
	}
	
	public function dropAllItems()
	{
		_headItem   = null;
		_torsoItem  = null;
		_legsItem   = null;
		_weaponItem = null;
	}
	
	public function restoreHealth()
	{
		health = _healthMax;
	}
	
	
    //#################################################################
}