package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Minimap extends FlxSpriteGroup 
{

	public function new(X:Float=0, Y:Float=0, curMap:TiledLevel) 
	{
		super(X, Y);
		
		alpha = 0.4;
		
		var mapOutline:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.4), Std.int(FlxG.height * 0.35));
		add(mapOutline);
		


		/*
		for (map in curMap.foregroundTiles.members)
		{
			var tilemap:FlxSprite = new FlxSprite().loadGraphic(map.graphic);
			
			
			mapOutline.stamp(tilemap);
		}
	*/
		
		
	}
	
}