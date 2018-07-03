package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
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
	
	public function new(?X:Float=0, ?Y:Float=0, mapPath:FlxPath) 
	{
		super(X, Y);
		
		patrolPath = mapPath;
		
		if (mapPath != null)
		{
			path = mapPath;
		}
		
		makeGraphic(TILE_SIZE, TILE_SIZE);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		// alertChecks();
	}
	
	public function onBeat():Void
	{
		// eventually change this so that say you make a noise, then they'll check out where you are currently
		if (!alerted && patrolPath == null)
		{
			path = null;
		}
		else if (patrolPath != null)
		{
			path = patrolPath;
		}
		
		if (path != null)
		{
			var pathAngle:Float = FlxAngle.asDegrees(Math.atan2(path.nodes[1].y - path.nodes[0].y, path.nodes[1].x - path.nodes[0].x));
			
			FlxG.log.add("Path angle: " + pathAngle);
			
			
			switch(pathAngle)
			{
				case 0:
					moveTo(FlxObject.RIGHT);
				case 90:
					moveTo(FlxObject.DOWN);
				case -90:
					moveTo(FlxObject.UP);
				case 180:
					moveTo(FlxObject.LEFT);
			}
			
			path.nodes.push(path.nodes.shift());
			
		}
		else if (FlxG.random.bool())
		{
			facing = FlxG.random.getObject([FlxObject.LEFT, FlxObject.RIGHT, FlxObject.UP, FlxObject.DOWN]);
			moveTo(facing);
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
			alertLevel += FlxG.elapsed;
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
}