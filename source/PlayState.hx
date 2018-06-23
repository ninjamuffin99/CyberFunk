package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	public var player_start:FlxObject;
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
	
	private var _barBeats:FlxSprite;
	private var _barBeatsKeys:FlxSprite;
	
	private var _txtPlayerHP:FlxText;
	
	private var _beatNoise:Float = 0;
	private var _playerNoise:Float = 0;
	
	private var noiseDiff:Float = 0;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 0.6;
		
		songInit();
		
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xff501111);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		
		initMap();
		
		_player = new Player(player_start.x, player_start.y);
		add(_player);
		
		add(_grpEnemies);
		
		persistentUpdate = true;
		persistentDraw = true;
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.LOCKON, 0.8);
		
		initHUD();
		
		super.create();
	}
	
	private function initMap():Void
	{
		_map = new TiledLevel("assets/data/testMap.tmx", this);
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
		
		_barBeats = new FlxSprite(30, 75).makeGraphic(8, 55, FlxColor.BLUE);
		_grpHUD.add(_barBeats);
		
		_barBeatsKeys = new FlxSprite(42, 75).makeGraphic(8, 55, FlxColor.BLUE);
		_grpHUD.add(_barBeatsKeys);
		
		_txtPlayerHP = new FlxText(10, 10, 0, "2/2", 12);
		_grpHUD.add(_txtPlayerHP);
		
		// sets each member in the group to not scroll
		_grpHUD.forEach(function(s:FlxSprite)
		{
			s.scrollFactor.set(); 
		});
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
		
		noiseDiff = _beatNoise - _playerNoise;
		
		FlxG.watch.addQuick("Noisey: ", noiseDiff);
		
		if (FlxG.keys.justPressed.R)
		{
			openSubState(new HackSubState(_song));
		}
		
		super.update(elapsed);
		
		if (_map.collideWithLevel(_player))
		{
			_player.moveToNextTile = false;
		}
		
		_grpEnemies.forEachAlive(enemyLogic);
		
		
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
				_grpEnemies.forEachAlive(function(e:Enemy)
				{
					e.onBeat(); 
				});
				
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
		if (_map.collideWithLevel(_enemy))
		{
			_enemy.moveToNextTile = false;
		}
		
		
		/*
		if (FlxG.collide(_player, _enemy))
		{
			_player.moveToNextTile = false;
			_enemy.moveToNextTile = false;
			
			// noticed
			if (isNoisy(0.5))
			{
				FlxG.log.add("HURT!!!");
			}
			else
			{
				FlxG.log.add("HACKED!!");
			}
		}
		*/
	}
	
	private function updateHUD():Void
	{
		_txtPlayerHP.text = _player.hp + "/" + _player.hpMax;
		
		_barBeats.scale.y = _beatNoise;
		_barBeatsKeys.scale.y = _playerNoise;
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
