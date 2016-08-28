package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class Player extends FlxSprite
{
    //#################################################################

	public var headItem   : Item;
	public var torsoItem  : Item;
	public var legsItem   : Item;
	public var weaponItem : Item;

	public var strength   : Float;
	public var agility    : Float;
	public var healthMax  : Float;

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
	var _dashCooldownBar: HudBar;

	var _inventory      : Inventory;
	var _showInventory  : Bool;
	var _npcInteraction : Bool;
	var _interactingNPC : NPC;

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
		legsItem = new Item(ItemType.LEGS, 'Iron Diaper', 10, 0, 0);
		weaponItem = new Item(ItemType.WEAPON, 'Mighty Longsword of Mutilation', 0, 20, 0);

		_playState = playState;

		setPosition(8 * GameProperties.TileSize, 2 * GameProperties.TileSize);
		
		health = healthMax = GameProperties.PlayerHealthMaxDefault;
		_healthBar = new HudBar(10, 10, 96, 16, false);
		
		_dashCooldownBar = new HudBar(10, 32, 48, 8, false);

		_inventory      = new Inventory(this);
		_showInventory  = false;
		_npcInteraction = false;
		
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
		
		
		_healthBar.health = health/healthMax;
		_healthBar.update(elapsed);
		_dashCooldownBar.update(elapsed);
		_dashCooldownBar.health = 1.0 - _dashCooldown / GameProperties.PlayerMovementDashCooldown;
		_coinsText.text = Std.string(_coins);
		_coinsText.update(elapsed);

		_inventory.update(elapsed);
    }

    //#################################################################

    function handleInput()
    {
		if(!_npcInteraction && MyInput.InventoryButtonJustPressed)
		{
			_showInventory = !_showInventory;
		}

		if(_npcInteraction || _showInventory)
		{
			// Don't handle player input here when interacting with an
			// NPC. Let the NPC handle the input instead.
			// TODO handle input when showing inventory

			if(_interactingNPC != null)
			{
				_interactingNPC.handleInput(this);
			}
			return;
		}

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
    }

    //#################################################################

	public function toggleNpcInteraction()
	{
		_npcInteraction = !_npcInteraction;
		
		if(!_npcInteraction)
		{
			_interactingNPC = null;
		}
	}

    //#################################################################

	public function pickupItem(item: Item)
	{
		switch(item.itemType)
		{
			case ItemType.HEAD:
				headItem = item;
			case ItemType.TORSO:
				torsoItem = item;
			case ItemType.LEGS:
				legsItem = item;
			case ItemType.WEAPON:
				weaponItem = item;
		}
	}

    //#################################################################

	function recalculateBonuses()
	{
		var agilityBonus  = 0.0;
		var strengthBonus = 0.0;
		var healthBonus   = 0.0;

		if(headItem != null)
		{
			agilityBonus  += headItem.agilityBonus;
			strengthBonus += headItem.strengthBonus;
			healthBonus   += headItem.healthBonus;
		}

		if(torsoItem != null)
		{
			agilityBonus  += torsoItem.agilityBonus;
			strengthBonus += torsoItem.strengthBonus;
			healthBonus   += torsoItem.healthBonus;
		}

		if(legsItem != null)
		{
			agilityBonus  += legsItem.agilityBonus;
			strengthBonus += legsItem.strengthBonus;
			healthBonus   += legsItem.healthBonus;
		}

		if(weaponItem != null)
		{
			agilityBonus  += weaponItem.agilityBonus;
			strengthBonus += weaponItem.strengthBonus;
			healthBonus   += weaponItem.healthBonus;
		}
	}

    //#################################################################

	function attack()
	{
		_attackCooldown += GameProperties.PlayerAttackCooldown;
		
		var enemyHit = false;
		for(enemy in _playState.level.enemies)
		{
			if(FlxG.overlap(_hitArea, enemy))
			{
				enemy.hit(GameProperties.PlayerAttackBaseDamage, this.x, this.y);
				enemyHit = true;
			}
		}

		if(!enemyHit)
		{
			for(npc in _playState.level.npcs)
			{
				if(FlxG.overlap(_hitArea, npc))
				{
					npc.interact();
					_npcInteraction = true;
					_interactingNPC = npc;
				}
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

    //#################################################################

	public function drawHud()
	{
		_healthBar.draw();
		_dashCooldownBar.draw();
		_coinsText.draw();
		
		if(_showInventory)
		{
			_inventory.draw();
		}
	}

    //#################################################################
	
	public function pickUpCoins() 
	{
		_coins += 1;
	}

    //#################################################################
	
	public function takeDamage(d:Float)
	{
		health -= d;
		if (health <= 0)
		{
			alive = false;
		}
	}

    //#################################################################
	
	public function dropAllItems()
	{
		headItem   = null;
		torsoItem  = null;
		legsItem   = null;
		weaponItem = null;
	}

    //#################################################################
	
	public function restoreHealth()
	{
		health = healthMax;
	}
	
    //#################################################################
}