package;

import flixel.FlxSprite;
import flixel.addons.text.FlxTextField;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class DescriptionBox extends FlxSpriteGroup 
{

	var hackText:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, titleText:String = "", descriptionText:String = "") 
	{
		super(X, Y);
		
		//var description:FlxText = new FlxText(20, 20, 250, descriptionText, 32);
		
		//add(description);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.hackSheet__png, AssetPaths.hackSheet__txt);
		
		
		hackText = new FlxSprite();
		hackText.frames = tex;
		var animFrams:Array<Int> = [];
		for (i in 0...20)
		{
			animFrams.push(i);
		}
		hackText.animation.add("new", animFrams, 24, false);
		hackText.animation.add("ded", [0]);
		add(hackText);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (visible)
		{
			hackText.animation.play("new");
		}
		else
		{
			hackText.animation.play("ded");
		}
		
		super.update(elapsed);
	}
	
	
}