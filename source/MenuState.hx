package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class MenuState extends FlxState 
{

	override public function create():Void 
	{
		FlxG.camera.bgColor = 0xFF454763;
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.title__png);
		add(bg);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function(){FlxG.switchState(new PlayState()); });
		}
		
		super.update(elapsed);
	}
	
}