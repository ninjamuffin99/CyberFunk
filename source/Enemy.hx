package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

/**
 * ...
 * @author 
 */
class Enemy extends CharBase
{
	
	public var alertness:Float = 0;
	private var maxAlertLevel:Float = 5;
	
	public var alertLevel:Float = 0;
	public var alerted:Bool = false;
	
	public var canSeePlayer:Bool = false;
	
	private var patrolPath:FlxPath;
	
	public var isBeingHacked:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, mapPath:FlxPath) 
	{
		super(X, Y);
		
		patrolPath = mapPath;
		
		if (mapPath != null)
		{
			path = mapPath;
		}
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.searchSheet__png, AssetPaths.searchSheet__txt);
		
		frames = tex;
		width = 128;
		height = 128;
		offset.x = 178;
		offset.y = 30;
		
		animation.add("lr", [0]);
		animation.add("d", [1]);
		animation.add("u", [2]);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!isBeingHacked)
		{
			alertChecks();
		}
		
		
		switch(facing)
		{
			case FlxObject.LEFT:
				animation.play("lr");
			case FlxObject.RIGHT:
				animation.play("lr");
			case FlxObject.UP:
				animation.play("u");
			case FlxObject.DOWN:
				animation.play("d");
		}
		
	}
	
	public function onBeat(tilemap:FlxTilemap):Void
	{
		// eventually change this so that say you make a noise, then they'll check out where you are currently
		if (!alerted && patrolPath == null)
		{
			path = null;
		}
		else if (patrolPath != null && path != patrolPath)
		{
			path = patrolPath;
		}
		
		if (path != null && !isBeingHacked)
		{
			if (path == patrolPath)
			{
				if (FlxMath.pointInCoordinates(path.nodes[path.nodeIndex + 1].x, path.nodes[path.nodeIndex + 1].y, x, y, width, height))
				{
					path.nodes.push(path.nodes.shift());
				}
			}
			
			var pathAngle:Float = FlxAngle.asDegrees(Math.atan2(path.nodes[path.nodeIndex + 1].y - path.nodes[path.nodeIndex].y, path.nodes[path.nodeIndex + 1].x - path.nodes[path.nodeIndex].x));
			
			switch(pathAngle)
			{
				case 0:
					moveTo(FlxObject.RIGHT, pathAngle);
				case 90:
					moveTo(FlxObject.DOWN, pathAngle);
				case -90:
					moveTo(FlxObject.UP, pathAngle);
				case 180:
					moveTo(FlxObject.LEFT, pathAngle);
			}
		}
		else if (FlxG.random.bool())
		{
			/*
			facing = FlxG.random.getObject([FlxObject.LEFT, FlxObject.RIGHT, FlxObject.UP, FlxObject.DOWN]);
			moveTo(facing);
			*/
		}
	}
	
	private function alertChecks():Void
	{
		
		if (alertness > 0.2 || alertness < -0.2)
		{
			alertLevel += FlxG.elapsed * 2;
			color = FlxColor.YELLOW;
		}
		else
		{
			alertLevel -= FlxG.elapsed;
			color = FlxColor.WHITE;
		}
		
		
		if (canSeePlayer)
		{
			alertLevel += FlxG.elapsed * 3;
			color = FlxColor.ORANGE;
		}
		
		if (maxAlertLevel < alertLevel)
		{
			alertLevel = maxAlertLevel;
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
	
	public function hacked():Void
	{
		kill();
	}
}