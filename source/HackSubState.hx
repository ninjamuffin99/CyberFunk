package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class HackSubState extends FlxSubState 
{
	
	private var song:FlxSound;
	private var bar:FlxSprite;
	private var bruteBar:FlxSprite;
	private var grpNotes:FlxTypedGroup<HackNote>;
	
	private var currentNotesHit:Int = 0;
	private var totalNotes:Int = 0;
	private var currentLiveNotes:Int = 0;
	
	private var txtNoteCounter:FlxText;
	
	public static var curOutcome:Outcome = NONE;
	private var hackPhone:FlxSprite;

	public function new(curSong:FlxSound, BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		song = curSong;
		
		bar = new FlxSprite(0, 90);
		bar.makeGraphic(FlxG.width, 5, FlxColor.RED);
		bar.scrollFactor.set();
		bar.visible = false;
		add(bar);
		
		hackPhone = new FlxSprite(-150, FlxG.height / FlxG.camera.zoom).loadGraphic(AssetPaths.hacking__png);
		hackPhone.setGraphicSize(Std.int(hackPhone.width * 1.44));
		hackPhone.updateHitbox();
		hackPhone.scrollFactor.set();
		FlxTween.tween(hackPhone, {y: -120}, 0.2, {ease:FlxEase.quartOut});
		add(hackPhone);
		
		bruteBar = new FlxSprite(bar.x, bar.y).makeGraphic(Std.int(bar.width), Std.int(bar.height), FlxColor.GREEN);
		bruteBar.scrollFactor.set();
		bruteBar.scale.x = 0;
		add(bruteBar);
		
		
		grpNotes = new FlxTypedGroup<HackNote>();
		add(grpNotes);
		
		for (i in 1...FlxG.random.int(9, 15))
		{
			totalNotes += 1;
			
			var newNote:HackNote;
			newNote = new HackNote(0, FlxG.height);
			newNote.notePos = FlxG.random.int(0, 3);
			newNote.x = 145 + (190 * newNote.notePos);
			newNote.strumTime = Conductor.songPosition + Conductor.crochet + (Conductor.crochet * i );
			newNote.scrollFactor.set();
			grpNotes.add(newNote);
		}
		
		totalNotes = Math.floor(totalNotes * 0.75);
		
		txtNoteCounter = new FlxText(0, 0, 0, "", 64);
		txtNoteCounter.color = FlxColor.MAGENTA;
		txtNoteCounter.scrollFactor.set();
		add(txtNoteCounter);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		txtNoteCounter.text = currentNotesHit + "/" + totalNotes;
		
		currentLiveNotes = 0;
		grpNotes.forEachAlive(noteFall);
		
		if (currentLiveNotes == 0)
		{
			if (currentNotesHit >= totalNotes)
			{
				curOutcome = HACKED;
			}
			else
			{
				curOutcome = FAILED;
			}
			tweenShit();
		}
		
		if (currentNotesHit >= totalNotes)
		{
			curOutcome = HACKED;
			tweenShit();
		}
		
		if (bruteBar.scale.x >= 1)
		{
			bruteBar.scale.x = 1;
			curOutcome = HACKED;
			tweenShit();
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			bruteBar.scale.x += FlxG.random.float(0.1, 0.4);
		}
		
		if (bruteBar.scale.x > 0)
		{
			bruteBar.scale.x -= FlxG.elapsed * 0.2;
		}
		
		super.update(elapsed);
	}
	
	private function noteFall(note:HackNote):Void
	{
		currentLiveNotes += 1;
		
		note.y = bar.y - ((Conductor.songPosition - note.strumTime) * 0.4);
		
		if (note.y < bar.y - note.height)
			note.kill();
		
		if (FlxG.overlap(note, bar))
		{
			if (FlxG.keys.justPressed.A && note.notePos == 0)
			{
				
				hitNote(note);
			}
				
			if (FlxG.keys.justPressed.S && note.notePos == 1)
			{
				
				hitNote(note);
			}
				
			if (FlxG.keys.justPressed.D && note.notePos == 2)
			{
				
				hitNote(note);
			}
				
			if (FlxG.keys.justPressed.F && note.notePos == 3)
			{
				
				hitNote(note);
			}
		}
	}
	
	private function hitNote(n:HackNote):Void
	{
		n.kill();
		currentNotesHit += 1;
	}
	
	
	private var tweeningOut:Bool = false;
	private function tweenShit():Void
	{
		if (!tweeningOut)
		{
			FlxTween.tween(hackPhone, {y:FlxG.height / FlxG.camera.zoom}, 0.3, {ease:FlxEase.quartIn, onComplete: function(tween:FlxTween
			){close(); }});
			tweeningOut = true;
		}
	}
}

enum Outcome
{
	NONE;
	HACKED;
	FAILED;//COMPLETION
	DEFEAT;//SUBMISSION
}