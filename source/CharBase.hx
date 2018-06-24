package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class CharBase extends FlxSprite 
{
	
	private var TILE_SIZE:Int = 128;
	public var MOVEMENT_SPEED:Int = 16;

	public var moveToNextTile:Bool;

	var moveDirection:Int;
	
	public var hp:Float = 2;
	public var hpMax:Float = 2;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		// Move the player to the next block
		if (moveToNextTile)
		{
			switch (moveDirection)
			{
				case FlxObject.UP:
					y -= MOVEMENT_SPEED;
				case FlxObject.DOWN:
					y += MOVEMENT_SPEED;
				case FlxObject.LEFT:
					x -= MOVEMENT_SPEED;
				case FlxObject.RIGHT:
					x += MOVEMENT_SPEED;
			}
		}
		
		// Check if the player has now reached the next block
		if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
		{
			moveToNextTile = false;
		}
	}
	
		
	public function moveTo(Direction:Int):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
			moveDirection = Direction;
			moveToNextTile = true;
		}
	}
}