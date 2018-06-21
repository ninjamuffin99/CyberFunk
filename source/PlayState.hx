package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
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
	
	private var _barBeats:FlxSprite;
	private var _barBeatsKeys:FlxSprite;
	
	private var _beatNoise:Float = 0;
	private var _playerNoise:Float = 0;
	
	private var noiseDiff:Float = 0;
	
	override public function create():Void
	{
		songInit();
		
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xff501111);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		
		_map = new TiledLevel("assets/data/testMap.tmx", this);
		add(_map.backgroundLayer);
		add(_map.imagesLayer);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		add(_map.foregroundTiles);
		
		_player = new Player(player_start.x, player_start.y);
		add(_player);
		
		
		add(_grpEnemies);
		
		persistentUpdate = true;
		persistentDraw = true;
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.LOCKON, 0.8);
		
		initHUD();
		
		super.create();
	}
	
	private function initHUD():Void
	{
		_barBeats = new FlxSprite(30, 75).makeGraphic(8, 55, FlxColor.BLUE);
		_barBeats.scrollFactor.set();
		add(_barBeats);
		
		_barBeatsKeys = new FlxSprite(42, 75).makeGraphic(8, 55, FlxColor.BLUE);
		_barBeatsKeys.scrollFactor.set();
		add(_barBeatsKeys);
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
		
		_barBeats.scale.y = _beatNoise;
		_barBeatsKeys.scale.y = _playerNoise;
		
		noiseDiff = _beatNoise - _playerNoise;
		
		// noticed
		if (noiseDiff > 0.2 || noiseDiff < -0.2)
		{
			// noticed()
		}
		
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
		
		/*
		if (_map.collideWithLevel(_enemy))
		{
			_enemy.moveToNextTile = false;
		}
		*/
		/*
		if (FlxG.overlap(_player, _enemy))
		{
			// noticed
			if (isNoisy(0.5))
			{
				FlxG.log.add("HURT!!!");
			}
			else
			{
				FlxG.log.add("HACKED!!");
			}
		}*/
		
		
		if (_player.justPressedKeys)
		{
			_playerNoise = 1;
		}
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
