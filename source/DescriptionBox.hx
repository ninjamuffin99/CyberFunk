package;

import flixel.FlxSprite;
import flixel.addons.text.FlxTextField;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class DescriptionBox extends FlxSpriteGroup 
{

	public function new(X:Float=0, Y:Float=0, titleText:String = "", descriptionText:String = "") 
	{
		super(X, Y);
		
		var description:FlxText = new FlxText(20, 20, 250, descriptionText, 32);
		
		var box:FlxSprite = new FlxSprite().makeGraphic(250, 34 * description.textField.numLines, FlxColor.RED);
		add(box);
		add(description);
		
		
	}
	
}