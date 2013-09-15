package classes
{
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TextEvent;
	import fl.managers.FocusManager;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.display.StageAlign;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Steve
	*/
	public class MusicReader extends MovieClip 
	{
		public var movNoteInfo:NoteInfo;
		//public var movStats:Stats;
		
		
		public var txtInput:TextField;
		public var frm:TextFormat;
		
		
		private var isKey:Boolean = false;
		
		private var key:String = "";
		private var register:Number = 2;
		private var note:String = "";
		private var volume:Number = 0.5;
		private var isSharp:Boolean = false;
		
		private var noteBin:Array;
		
		public function MusicReader() 
		{
			var noteCounter:int;
			var noteLetter:String;
			var reqNote:URLRequest;
			
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			txtInput = new TextField;
			txtInput.multiline = true;
			txtInput.wordWrap = true;
            txtInput.selectable = false;
			//txtInput.embedFonts = true;
			
			
			stage.addEventListener(KeyboardEvent.KEY_UP, textHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			frm = new TextFormat();
			frm.font = "fntText";
			frm.color = 0xEFEFEF;
			frm.size = 75;
			
			txtInput.defaultTextFormat = frm;
			//txtInput.setTextFormat(frm);
			addChild(txtInput);
			
			noteBin = new Array();
			
			for (var i:int = 0; i <= 4; i++) {
				noteBin[i] = new Array();
				noteCounter = 1;
				while (noteCounter <= 12)
				{
					switch (noteCounter) {
						case 1:
						noteLetter = "A";
						break;
						case 2:
						noteLetter = "A#";
						break;
						case 3:
						noteLetter = "B";
						break;
						case 4:
						noteLetter = "C";
						break;
						case 5:
						noteLetter = "C#";
						break;
						case 6:
						noteLetter = "D";
						break;
						case 7:
						noteLetter = "D#";
						break;
						case 8:
						noteLetter = "E";
						break;
						case 9:
						noteLetter = "F";
						break;
						case 10:
						noteLetter = "F#";
						break;
						case 11:
						noteLetter = "G";
						break;
						case 12:
						noteLetter = "G#";
						break;
					}
					
					noteBin[i][noteLetter] = "notes//" + String(i) + "//" + noteLetter + ".wav";
				}
			}
			
		}
		
		private function stageHandler(_event:Event):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			this.resizeHandler(null);
			
			txtInput.stage.focus = txtInput;
			stage.addEventListener(KeyboardEvent.KEY_UP, textHandler);

			
		}
		
		private function resizeHandler(_event:Event):void
		{
			txtInput.width = stage.stageWidth;
			txtInput.height = stage.stageHeight / 2;
			
			while (txtInput.textHeight > (stage.stageHeight / 2)) {
				txtInput.replaceText(0, txtInput.getLineLength(1), "");
			}
			
			movNoteInfo.x = stage.stageWidth;
			movNoteInfo.y = stage.stageHeight;
			
		}
		
		private function textHandler(_event:KeyboardEvent):void 
		{
			parseText(_event.charCode);
			//txtInput.setTextFormat(frm);
			
		}
		
		private function parseText(_text:Number):void 
		{
			//trace(_text);
			
			var letter:String = String.fromCharCode(_text);
			var upperLetter:String = letter.toUpperCase();
			var upperText:Number = upperLetter.charCodeAt();
			var numNote:Number = 0;
			var sndNote:Sound;
			var sndChannel:SoundChannel;
			
			switch (letter)
			{
				case ".":
				isKey = false;
				key = "";
				register = 2;
				volume = 0.6;
				isSharp = false;
				break;
				
			}
			
			//determine capital
			if ((_text > 64) && (_text < 91))
			{
				volume *= 1.1;
			
			}  else {
				
				volume = 0.6;
			}
			
			if ((upperText > 64) && (upperText < 72))
			{
				if (!isKey)
				{
					//key
					key = upperLetter;
					
					switch (upperLetter) {
						case "C":
						case "D":
						case "F":
						case "G":
						case "A":
						if (isSharp)
						{
							key += "#";
						}
						break;
					}
					
					isKey = true;
				} else {
					//note
					note = determineNote(key, upperLetter);
					
				}
			} else {
				
				if (!isKey)
				{
					//sharp and flat determiner for key
					if ((upperText > 71) && (upperText < 81))
					{
						isSharp = true;
					} else if ((upperText > 80) && (upperText < 91)) {
						isSharp = false;
					}
				} else {
					//register
					if ((upperText > 71) && (upperText < 81))
					{
						register = (register < 4)? register + 1 : register;
					} else if ((upperText > 80) && (upperText < 91)) {
						register = (register > 0)? register - 1 : register;
					}
				}
				
				
			}
			
			//play the note
			sndNote = new Sound(new URLRequest(noteBin[register][note]));
			sndNote.play();
			
			
			//add to the output
			txtInput.appendText(letter);
			if (txtInput.textHeight > (stage.stageHeight / 2)) {
				txtInput.replaceText(0, txtInput.getLineLength(1), "");
			}
			
			//show the info
			movNoteInfo.setText("key", key);
			movNoteInfo.setText("note", note);
			movNoteInfo.setText("register", String(register));
			
			//stats
			/*movStats.addStat("vol", String(volume));
			movStats.addStat("key", key);
			movStats.addStat("reg", String(register));
			movStats.addStat("note", note);*/
			
		}
		
		private function determineNote(_key:String, _letter:String):String 
		{
			switch (_key) {
				case "A":
				switch (_letter) {
					case "C":
					case "F":
					case "G":
					return _letter + "#";
					break;
				}
				break;
				
				case "A#":
				switch (_letter) {
					case "A":
					return _letter + "#";
					break;
					case "E":
					return "D#";
					break;
				}
				break;
				
				case "B":
				switch (_letter) {
					case "C":
					case "D":
					case "F":
					case "G":
					case "A":
					return _letter + "#";
					break;
				}
				break;
				
				case "C":
				return _letter;
				break;
				
				case "C#":
				switch (_letter) {
					case "C":
					case "D":
					case "F":
					case "G":
					case "A":
					return _letter + "#";
					break;
					
					case "E":
					return "F";
					break;
					
					case "B":
					return "C";
					break;
				}
				break;
				
				case "D":
				switch (_letter) {
					case "F":
					case "C":
					return _letter + "#";
					break;
				}
				break;
				
				case "D#":
				switch (_letter) {
					case "D":
					case "G":
					case "A":
					return _letter + "#";
					break;
				}
				break;
				
				case "E":
				switch (_letter) {
					case "F":
					case "G":
					case "C":
					case "D":
					return _letter + "#";
					break;
				}
				break;
				
				case "F":
				switch (_letter) {
					case "B":
					return "A#";
					break;
				}
				break;
				
				case "F#":
				switch (_letter) {
					case "F":
					case "G":
					case "A":
					case "C":
					case "D":
					return _letter + "#";
					break;
					
					case "E":
					return "F";
					break;
				}
				break;
				
				case "G":
				switch (_letter) {
					case "F":
					return _letter + "#";
					break;
				}
				break;
				
				case "G#":
				switch (_letter) {
					case "G":
					case "A":
					case "D":
					return _letter + "#";
					break;
				}
				break;
			}
			
			return null;
		}
		
	}
	
	
	
}