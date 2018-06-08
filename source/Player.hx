package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author
 */

enum MoveDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class Player extends FlxSprite
{
	static inline var TILE_SIZE:Int = 16;
	static inline var MOVEMENT_SPEED:Int = 4;

	public var moveToNextTile:Bool;

	var moveDirection:MoveDirection;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		makeGraphic(TILE_SIZE, TILE_SIZE, FlxColor.GREEN);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		// Move the player to the next block
		if (moveToNextTile)
		{
			switch (moveDirection)
			{
				case UP:
					y -= MOVEMENT_SPEED;
				case DOWN:
					y += MOVEMENT_SPEED;
				case LEFT:
					x -= MOVEMENT_SPEED;
				case RIGHT:
					x += MOVEMENT_SPEED;
			}
		}
		
		// Check if the player has now reached the next block
		if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
		{
			moveToNextTile = false;
		}
		
		
		if (FlxG.keys.anyJustPressed([DOWN, S]))
		{
			moveTo(MoveDirection.DOWN);
		}
		else if (FlxG.keys.anyJustPressed([UP, W]))
		{
			moveTo(MoveDirection.UP);
		}
		else if (FlxG.keys.anyJustPressed([LEFT, A]))
		{
			moveTo(MoveDirection.LEFT);
		}
		else if (FlxG.keys.anyJustPressed([RIGHT, D]))
		{
			moveTo(MoveDirection.RIGHT);
		}
	}
	
	public function moveTo(Direction:MoveDirection):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
			moveDirection = Direction;
			moveToNextTile = true;
		}
	}

}