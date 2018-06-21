package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author
 */


class Player extends CharBase
{
	
	public var justPressedKeys:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		makeGraphic(TILE_SIZE, TILE_SIZE, FlxColor.GREEN);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		if (FlxG.keys.anyJustPressed([DOWN, S]))
		{
			moveTo(FlxObject.DOWN);
		}
		else if (FlxG.keys.anyJustPressed([UP, W]))
		{
			moveTo(FlxObject.UP);
		}
		else if (FlxG.keys.anyJustPressed([LEFT, A]))
		{
			moveTo(FlxObject.LEFT);
		}
		else if (FlxG.keys.anyJustPressed([RIGHT, D]))
		{
			moveTo(FlxObject.RIGHT);
		}
		else
			justPressedKeys = false;
	}

	override public function moveTo(Direction:Int):Void 
	{
		super.moveTo(Direction);
		
		justPressedKeys = true;
	}
	
}