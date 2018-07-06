package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

/**
 * ...
 * @author
 */


class Player extends CharBase
{
	
	public var justPressedKeys:Bool = false;
	public var isHacking:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.playerSheet__png, AssetPaths.playerSheet__txt);
		
		frames = tex;
		
		animation.addByIndices("idle", "player", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24);
		animation.play("idle");
		
		width = TILE_SIZE;
		height = TILE_SIZE;
		offset.y += 64;
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!isHacking)
		{
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
	}

	override public function moveTo(Direction:Int, angleDir:Float = 0):Void 
	{
		super.moveTo(Direction, angleDir);
		
		justPressedKeys = true;
	}
}