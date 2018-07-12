package;

import flixel.FlxCamera;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField3D;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapDiagonalPolicy;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	private var _player:Player;
	public var player_start:FlxObject;
	public var levelExit:FlxObject;
	private var bg:FlxSprite;
	
	public var _grpEnemies:FlxTypedGroup<Enemy>;
	
	private var _song:FlxSound;
	private var lastBeat:Float;
	private var totalBeats:Int = 0;
	
	private var safeZoneOffset:Float = 0;
	private var safeFrames:Int = 13;
	private var canHit:Bool = false;
	
	public var _map:TiledLevel;
	
	// Hud shit
	private var _grpHUD:FlxTypedGroup<FlxSprite>;
	
	private var _miniMap:Minimap;
	
	private var _barBeats:FlxSprite;
	private var _barBeatsKeys:FlxSprite;
	
	private var _txtPlayerHP:FlxText;
	
	private var _beatNoise:Float = 0;
	private var _playerNoise:Float = 0;
	
	private var noiseDiff:Float = 0;
	
	
	public var curLevel:Int = 0;
	public var levelsArray:Array<String> =
	[
		"assets/data/level2",
		"assets/data/level3",
		"assets/data/level4",
		"assets/data/level5",
		"assets/data/level6"
	];
	
	public var _grpHackables:FlxTypedGroup<HackableObject>;
	
	public var hackBox:HackableObject;
	private var infoBox:DescriptionBox;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 0.6;
		
		songInit();
		
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xff501111);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		_grpHackables = new FlxTypedGroup<HackableObject>();
				
		_barBeats = new FlxSprite(30, 75).loadGraphic(AssetPaths.circlePNG__png);
		_barBeats.color = FlxColor.RED;
		add(_barBeats);
		
		_barBeatsKeys = new FlxSprite(42, 75).loadGraphic(AssetPaths.circlePNG__png);
		_barBeatsKeys.color = FlxColor.BLUE;
		add(_barBeatsKeys);
		
		initMap();

		_player = new Player(player_start.x, player_start.y);
		add(_player);
		
		add(_grpHackables);
		
		add(_grpEnemies);
		
		persistentUpdate = true;
		persistentDraw = true;
		
		FlxG.camera.focusOn(_player.getPosition());
		FlxG.camera.follow(_player, FlxCameraFollowStyle.SCREEN_BY_SCREEN, 0.2);
		var followLead:Float = 0.45;
		FlxG.camera.followLead.set(followLead, followLead);
		
		initHUD();
		
		super.create();
	}
	
	private function initMap():Void
	{
		_map = new TiledLevel(levelsArray[curLevel] + ".tmx", this);
		add(_map.backgroundLayer);
		add(_map.imagesLayer);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		add(_map.foregroundTiles);
	}
	
	private function initHUD():Void
	{
		_grpHUD = new FlxTypedGroup<FlxSprite>();
		add(_grpHUD);

		_txtPlayerHP = new FlxText(10, 10, 0, "2/2", 12);
		_grpHUD.add(_txtPlayerHP);
		
		_miniMap = new Minimap(FlxG.width * -0.3, FlxG.height * -0.3, _map);
		// _grpHUD.add(_miniMap);
		
		infoBox = new DescriptionBox(0, 0, "", "this is a test lmaooooo");
		infoBox.visible = false;
		add(infoBox);
		
		// sets each member in the group to not scroll
		_grpHUD.forEach(function(s:FlxSprite)
		{
			s.scrollFactor.set(); 
		});
	}
	
	private function reloadMap():Void
	{
		remove(_map.backgroundLayer);
		remove(_map.imagesLayer);
		remove(_map.BGObjects);
		remove(_map.foregroundObjects);
		remove(_map.objectsLayer);
		remove(_map.foregroundTiles);
		
		remove(_grpHUD);
		
		curLevel += 1;
		
		_grpEnemies.forEachExists(function(e:Enemy){e.kill(); });
		
		_map = new TiledLevel(levelsArray[curLevel] + ".tmx", this);
		
		_player.setPosition(player_start.x, player_start.y);
		
		add(_map.backgroundLayer);
		add (_map.imagesLayer);
		//the _map.foregroundLayer is added later so that it's above the enemies and shit
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		
		add(_map.foregroundTiles);
		
		add(_grpHUD);
	}
	
	
	private function songInit():Void
	{
		_song = new FlxSound();
		_song.loadEmbedded("assets/music/808176_-Coast-.mp3", true, false, finishSong);
		add(_song);
		_song.play();
		
		lastBeat = 0;
	}
	
	private function finishSong():Void
	{
		_song.time = 0;
		lastBeat = 0;
		totalBeats = 0;
	} 

	override public function update(elapsed:Float):Void
	{
		// text/info box
		var hackObjsNear:Int = 0;
		for (h in _grpHackables.members)
		{
			if (FlxMath.isDistanceWithin(_player, h, 150) && h.alive)
			{
				hackObjsNear += 1;
				if (FlxG.keys.justPressed.SPACE && !_player.isHacking)
				{
					openSubState(new HackSubState(_song));
					_player.isHacking = true;
				}
				
				if (_player.isHacking && HackSubState.curOutcome != HackSubState.Outcome.NONE)
				{
					if (HackSubState.curOutcome == HackSubState.Outcome.HACKED)
					{
						h.hacked();
					}
					
					_player.isHacking = false;
					HackSubState.curOutcome = HackSubState.Outcome.NONE;
				}
			}
		}
		
		for (e in _grpEnemies.members)
		{
			if (FlxMath.isDistanceWithin(_player, e, 150) && e.alive)
			{
				hackObjsNear += 1;
				if (FlxG.keys.justPressed.SPACE && !_player.isHacking && !e.canSeePlayer)
				{
					openSubState(new HackSubState(_song));
					_player.isHacking = true;
					e.isBeingHacked = true;
				}
				
				if (_player.isHacking && HackSubState.curOutcome != HackSubState.Outcome.NONE)
				{
					if (HackSubState.curOutcome == HackSubState.Outcome.HACKED)
					{
						e.hacked();
					}
					else
					{
						e.isBeingHacked = false;
					}
					_player.isHacking = false;
					HackSubState.curOutcome = HackSubState.Outcome.NONE;
				}
			}
		}
		
		if (hackObjsNear > 0)
		{
			infoBox.visible = true;
			infoBox.setPosition(_player.x + 80, _player.y - 100);
		}
		else
			infoBox.visible = false;
		
			
		if (FlxG.overlap(levelExit, _player))
		{
			reloadMap();
		}
		
		songHandling();
		
		bg.alpha -= FlxG.elapsed / 2;
		if (_beatNoise > 0)
		{
			_beatNoise -= FlxG.elapsed / (Conductor.crochet * 0.001);
		}
		
		if (_playerNoise > 0)
		{
			_playerNoise -= FlxG.elapsed / (Conductor.crochet * 0.001);
		}
		
		if (_playerNoise > 0)
		{
			noiseDiff = _beatNoise - _playerNoise;
		}
		else
		{
			noiseDiff = 0;
		}
		
		super.update(elapsed);
		
		if (_map.collideWithLevel(_player))
		{
			_player.moveToNextTile = false;
		}
		
		_grpEnemies.forEachAlive(enemyLogic);
		
		if (FlxG.collide(_player, _grpHackables))
		{
			_player.moveToNextTile = false;
		}
		
		if (_player.justPressedKeys)
		{
			_playerNoise = 1;
		}
		
		updateHUD();
	}
	
	private function songHandling():Void
	{
		Conductor.songPosition = _song.time;
		
		//	SHOUTOUTS TO FermiGames MVP MVP
		if (Conductor.songPosition > lastBeat + Conductor.crochet - safeZoneOffset || Conductor.songPosition < lastBeat + safeZoneOffset) 
		{
			canHit = true;
			
			// every beat 	
			if (Conductor.songPosition > lastBeat + Conductor.crochet)
			{
				_grpEnemies.forEachAlive(enemyLogicOnBeat);
				
				lastBeat += Conductor.crochet;
				totalBeats += 1;
				bg.alpha = 1;
				_beatNoise = 1;
			}
		}
		else
			canHit = false;
	}
	
	private function enemyLogic(_enemy:Enemy):Void
	{
		if (_enemy.isOnScreen())
		{
			_enemy.alertness = noiseDiff;
		}
		else
		{
			_enemy.alertness = 0;
		}
		
		// vision logic simple
		if (_map.collidableTileLayers[0].ray(_enemy.getMidpoint(), _player.getMidpoint()) && FlxMath.isDistanceWithin(_player, _enemy, _player.width * 5.1) && !_player.isDisguised)
		{
			var rads:Float = Math.atan2(_player.getMidpoint().y - _enemy.getMidpoint().y, _player.getMidpoint().x - _enemy.getMidpoint().x);
			var degs = FlxAngle.asDegrees(rads);
			
			var angleView:Float = 35;
			
			var minView:Float = FlxMath.bound(_enemy.angleFacing - angleView, -179.9, 180);
			var maxView:Float = FlxMath.bound(_enemy.angleFacing + angleView, -179.9, 180);
			
			switch(_enemy.botType)
			{
				case Enemy.PATROL:
					if (degs >= minView && degs <= _enemy.angleFacing + maxView)
					{
						_enemy.canSeePlayer = true;
					}
					else
					{
						_enemy.canSeePlayer = false;
					}
				case Enemy.EYE:
					_enemy.canSeePlayer = true;
				case Enemy.DOG:
					_enemy.canSeePlayer = false;
			}
		}
		else
		{
			_enemy.canSeePlayer = false;
		}
		
		if (_map.collideWithLevel(_enemy))
		{
			_enemy.moveToNextTile = false;
		}
		
		if (FlxG.overlap(_enemy, _player))
		{
			
			if (_enemy.canSeePlayer)
			{
				FlxG.resetState();
			}
		}
	}
	
	private function enemyLogicOnBeat(_enemy:Enemy):Void
	{
		if (_enemy.alerted)
		{
			var pathPoints:Array<FlxPoint> = _map.collidableTileLayers[0].findPath(
					FlxPoint.get(_enemy.x + _enemy.width / 2, _enemy.y + _enemy.height / 2),
					FlxPoint.get(_player.x + _player.width / 2, _player.y + _player.height / 2), true, false, FlxTilemapDiagonalPolicy.NONE);
				
			if (pathPoints != null)
			{
				if (_enemy.path == null)
				{
					_enemy.path = new FlxPath();
				}
				
				_enemy.path.nodes = pathPoints;
			}
		}
		
		_enemy.onBeat(_map.collidableTileLayers[0]); 
	}
	
	private function updateHUD():Void
	{
		_txtPlayerHP.text = _player.hp + "/" + _player.hpMax;
		
		_barBeats.setPosition(_player.getGraphicMidpoint().x - (_barBeats.width / 2), _player.getGraphicMidpoint().y - (_barBeats.height / 2));
		_barBeatsKeys.setPosition(_barBeats.x, _barBeats.y);
		
		_barBeats.scale.set(_beatNoise, _beatNoise);
		_barBeatsKeys.scale.set(_playerNoise, _playerNoise);
		
		_barBeats.alpha = _beatNoise;
		_barBeatsKeys.alpha = _playerNoise;
		
	}
	
	private function isNoisy(noiseAmount:Float):Bool
	{
		if (noiseDiff > noiseAmount || noiseDiff < -noiseAmount)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
