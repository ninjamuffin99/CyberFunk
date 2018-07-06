package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class HackableObject extends FlxSprite 
{
	
	public var descritpion:String = "testName";
	public var name:String = "goodAssDescriptionLOLOL";
	public var hackType:String = "";
	
	public var isHacking:Bool = false;
	
	public static inline var DOOR:String = "door";

	public function new(?X:Float=0, ?Y:Float=0, type:String) 
	{
		super(X, Y);
		
		makeGraphic(128, 128, FlxColor.GREEN);
		
		hackType = type;
		
		immovable = true;
	}
	
	public function hacked():Void
	{
		switch(hackType)
		{
			case DOOR:
				kill();
		}
	}
	
}