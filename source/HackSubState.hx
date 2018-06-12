package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class HackSubState extends FlxSubState 
{
	
	private var song:FlxSound;
	
	private var bar:FlxSprite;
	private var grpNotes:FlxTypedGroup<HackNote>;

	public function new(curSong:FlxSound, BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		
		song = curSong;
		
		bar = new FlxSprite(0, 16);
		bar.makeGraphic(FlxG.width, 5);
		add(bar);
		
		grpNotes = new FlxTypedGroup<HackNote>();
		add(grpNotes);
		
		for (i in 0...FlxG.random.int(4, 10))
		{
			var newNote:HackNote;
			newNote = new HackNote(0, FlxG.height);
			newNote.notePos = FlxG.random.int(0, 3);
			newNote.x = ((FlxG.width / 4) * newNote.notePos);
			newNote.strumTime = Conductor.songPosition + Conductor.crochet + (Conductor.crochet * i );
			grpNotes.add(newNote);
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		grpNotes.forEachAlive(noteFall);
		
		if (FlxG.keys.justPressed.T)
		{
			close();
		}
		
		super.update(elapsed);
	}
	
	private function noteFall(note:HackNote):Void
	{
		note.y = bar.y - ((Conductor.songPosition - note.strumTime) * 0.3);
		
		if (note.y < 0 - note.height)
			note.kill();
		
		if (FlxG.overlap(note, bar))
		{
			if (FlxG.keys.justPressed.ONE && note.notePos == 0)
				note.kill();
				
			if (FlxG.keys.justPressed.TWO && note.notePos == 1)
				note.kill();
				
			if (FlxG.keys.justPressed.THREE && note.notePos == 2)
				note.kill();
				
			if (FlxG.keys.justPressed.FOUR && note.notePos == 3)
				note.kill();
		}
	}
	
}