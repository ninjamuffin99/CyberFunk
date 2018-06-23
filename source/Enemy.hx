package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Enemy extends CharBase
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(TILE_SIZE, TILE_SIZE);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
	}
	
	public function onBeat():Void
	{
		if (FlxG.random.bool())
		{
			 moveTo(FlxG.random.getObject([FlxObject.LEFT, FlxObject.RIGHT, FlxObject.UP, FlxObject.DOWN]));
		}
	}
}