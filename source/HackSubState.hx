package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
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

	public function new(curSong:FlxSound, BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		song = curSong;
		
		bar = new FlxSprite(0, 16);
		bar.makeGraphic(FlxG.width, 5, FlxColor.RED);
		bar.scrollFactor.set();
		add(bar);
		
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
			newNote.x = ((FlxG.width / 4) * newNote.notePos);
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
			close();
		}
		
		if (currentNotesHit >= totalNotes)
		{
			curOutcome = HACKED;
			close();
		}
		
		if (bruteBar.scale.x >= 1)
		{
			bruteBar.scale.x = 1;
			curOutcome = HACKED;
			close();
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
		
		if (note.y < 0 - note.height)
			note.kill();
		
		if (FlxG.overlap(note, bar))
		{
			if (FlxG.keys.justPressed.ONE && note.notePos == 0)
			{
				
				hitNote(note);
			}
				
			if (FlxG.keys.justPressed.TWO && note.notePos == 1)
			{
				
				hitNote(note);
			}
				
			if (FlxG.keys.justPressed.THREE && note.notePos == 2)
			{
				
				hitNote(note);
			}
				
			if (FlxG.keys.justPressed.FOUR && note.notePos == 3)
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
	
	
}

enum Outcome
{
	NONE;
	HACKED;
	FAILED;//COMPLETION
	DEFEAT;//SUBMISSION
}