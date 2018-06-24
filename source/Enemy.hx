package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Enemy extends CharBase
{
	
	public var alertness:Float = 0;
	
	public var alertLevel:Float = 0;
	public var alerted:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(TILE_SIZE, TILE_SIZE);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (alertness > 0.2 || alertness < -0.2)
		{
			alertLevel += FlxG.elapsed;
			color = FlxColor.ORANGE;
		}
		else
		{
			alertLevel -= FlxG.elapsed;
			color = FlxColor.WHITE;
		}
		
		
		if (alertLevel >= 3)
		{
			color = FlxColor.RED;
			alerted = true;
		}
		else
		{
			alerted = false;
		}
		
	}
	
	public function onBeat():Void
	{
		if (FlxG.random.bool())
		{
			facing = FlxG.random.getObject([FlxObject.LEFT, FlxObject.RIGHT, FlxObject.UP, FlxObject.DOWN]);
			moveTo(facing);
		}
	}
}