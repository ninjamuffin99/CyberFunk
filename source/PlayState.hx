package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;

class PlayState extends FlxState
{
	private var _player:Player;
	private var bg:FlxSprite;
	
	private var _song:FlxSound;
	private var lastBeat:Float;
	private var totalBeats:Int = 0;
	
	private var safeZoneOffset:Float = 0;
	private var safeFrames:Int = 13;
	private var canHit:Bool = false;
	
	public var _map:TiledLevel;
	
	override public function create():Void
	{
		songInit();
		
		
		
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xff501111);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		_map = new TiledLevel("assets/data/testMap.tmx", this);
		add(_map.backgroundLayer);
		add(_map.imagesLayer);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		add(_map.foregroundTiles);
		
		_player = new Player(16 * 5, 16 * 5);
		add(_player);
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.LOCKON, 0.8);
		
		
		super.create();
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
		
		super.update(elapsed);
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
				lastBeat += Conductor.crochet;
				totalBeats += 1;
				bg.alpha = 1;
			}
		}
		else
			canHit = false;

	}
}
