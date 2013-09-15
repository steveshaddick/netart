package classes
{
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
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
	import flash.utils.getTimer;
	import classes.ADSREnvelope;
	import flash.system.System;
	import flash.display.StageScaleMode;
	import flash.net.navigateToURL;
	
	/**
	* ...
	* @author Steve
	*/
	public class MusicReader extends MovieClip 
	{
		public var movNoteInfo:NoteInfo;
		public var movCredit:MovieClip;
		public var movLoading:MovieClip;
		public var txtCount:TextField;
		public var txtStatus:TextField;
		//public var movStats:Stats;
		
		public var txtInput:TextField;
		public var frm:TextFormat;
		
		private var register:Number = 2;
		private var note:String = "";
		private var volume:Number = 0.5;
		private var sharpFlat:Number = 0;
		private var isSharpChanged:Boolean = false;
		private var isSlur:Boolean = false;
		private var isStaccato:Boolean = false;
		
		private var tnsVolume:SoundTransform = new SoundTransform();
		
		private var noteBin:Array;
		
		private var lastNow:uint = 0;
		private var lastElapsed:uint = 100;
		
		private var totalNotes:Number = 0;
		private var loadedNotes:Number = 0;
		
		private var alphaChange:Number = -0.05;
		
		public function MusicReader() 
		{
			var noteCounter:int;
			var noteLetter:String;
			var reqNote:URLRequest;
			
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			txtInput = new TextField();
			txtInput.multiline = true;
			txtInput.wordWrap = true;
            txtInput.selectable = false;
			//txtInput.embedFonts = true;
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, textHandler);
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
						noteLetter = "Asharp";
						break;
						case 3:
						noteLetter = "B";
						break;
						case 4:
						noteLetter = "C";
						break;
						case 5:
						noteLetter = "Csharp";
						break;
						case 6:
						noteLetter = "D";
						break;
						case 7:
						noteLetter = "Dsharp";
						break;
						case 8:
						noteLetter = "E";
						break;
						case 9:
						noteLetter = "F";
						break;
						case 10:
						noteLetter = "Fsharp";
						break;
						case 11:
						noteLetter = "G";
						break;
						case 12:
						noteLetter = "Gsharp";
						break;
					}
					
					//noteBin[i][noteLetter] = "notes//" + String(i) + "//" + noteLetter + ".wav";
					noteBin[i][noteLetter] = new Sound(new URLRequest("notes/" + String(i) + "/" + noteLetter.toLowerCase() + ".mp3"));
					noteBin[i][noteLetter].addEventListener(Event.COMPLETE, soundCompleteHandler);
					noteCounter ++;
					this.totalNotes ++;
					
				}
			}
			
			movLoading.alpha = 0.05;
			this.addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		private function stageHandler(_event:Event):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.resizeHandler(null);
			
			txtInput.stage.focus = txtInput;

			
		}
		
		private function resizeHandler(_event:Event):void
		{
			txtInput.width = stage.stageWidth;
			txtInput.height = (stage.stageHeight);
			
			movCredit.y = stage.stageHeight;
			
			while (txtInput.textHeight > ((stage.stageHeight / 4)*3)) {
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
		
		private function soundCompleteHandler(_event:Event):void 
		{
			this.loadedNotes++;
			txtCount.text = String(this.loadedNotes) + " of " + String(this.totalNotes);
			//trace(_event.target.url);
			//trace(txtCount.text);
			//txtStatus.text = _fevent.target.url;
		}
		
		private function frameHandler(_event:Event):void 
		{
			if (this.loadedNotes < this.totalNotes) {
				if (movLoading.alpha < 0.1) {
					this.alphaChange = 0.025;
				} else if (movLoading.alpha > 0.9) {
					this.alphaChange = -0.025;
				}
				
				movLoading.alpha += this.alphaChange;
			} else {
				this.removeChild(movLoading);
				this.removeChild(txtCount);
				this.removeEventListener(Event.ENTER_FRAME, frameHandler);
				navigateToURL(new URLRequest("javascript:MusicReader.focus();void 0;"),"_self");
				txtInput.stage.focus = txtInput;
			}
		}
		
		private function parseText(_text:Number):void 
		{
			//trace(_text);
			
			if ((_text <32) || (_text >126))
			{
				if (_text != 13) return;
			}
			
			var thisNow:uint = getTimer();
			var elapsed:uint = thisNow - lastNow;
			lastNow = thisNow;
			
			//trace(elapsed);
			var letter:String = String.fromCharCode(_text);
			var upperLetter:String = letter.toUpperCase();
			var upperText:Number = upperLetter.charCodeAt();
			var numNote:Number = 0;
			
			movNoteInfo.illuminate();
			
			isSharpChanged = false;
			
			switch (letter)
			{
				case ".":
				register = 2;
				volume = 0.6;
				sharpFlat = 0;
				note = "";
				break;
				
				case ",":
				volume *= 0.90;
				break;
				case "-":
				volume *= 0.90;
				break;
				
				case "!":
				volume *= 1.25;
				register = 2;
				sharpFlat = 0;
				note = "";
				break;
				
				case "?":
				note = "";
				break;
				
				case " ":
				volume *= 0.90;
				break;
				
				case "(":
				isSlur = true;
				break;
				
				case ")":
				isSlur = false;
				break;
				
				case '"':
				if (isStaccato) {
					isStaccato = false;
				} else {
					isStaccato = true;
				}
				
			}
			
			//determine capital
			if ((_text > 64) && (_text < 91))
			{
				if (volume < 0.75 ) {
					volume = 0.75;
				} else {
					volume *= 1.1;
				}
			} else {
				if (volume > 0.75) {
					volume = 0.75;
				}
			}
			
			//determine speed
			//trace(elapsed +":" + lastElapsed);
			if (elapsed < 200){
				volume *= 1.05;
			} else if (elapsed > 500){
				volume *= 0.95;
			}
		
			// limit volume extremes
			if (volume > 1) {
				//trace("before "+volume);
				volume = 1;
				//trace("after "+volume);
			} else if (volume < 0.1) {
				volume = 0.1;
			}
			
			lastElapsed = elapsed;
			
			if ((upperText > 64) && (upperText < 72))
			{
				
				note = upperLetter;
				
				if (sharpFlat == 1) {
					switch (note) {
						case "A":
						case "C":
						case "D":
						case "F":
						case "G":
						note = note + "sharp";
						break;
						
						case "B":
						note = "C";
						break;
						
						case "E":
						note = "F";
						break;
					}
				} else if (sharpFlat == -1) {
					switch (note) {
						case "A":
						note = "Gsharp";
						break;
						case "B":
						note = "Asharp";
						break;
						case "C":
						note = "B";
						break;
						case "D":
						note = "Csharp";
						break;
						case "E":
						note = "Dsharp";
						break;
						case "F":
						note = "E";
						break;
						case "G":
						note = "Fsharp";
						break;
					}
				}
				
				playNote();
					
			} else {
				
				//sharp, or flat, or neutral
				if (upperText == 73) {
					sharpFlat = 1;
					isSharpChanged = true;
				} else if (upperText == 79) {
					sharpFlat = -1;
					isSharpChanged = true;
				} else if (upperText == 85) {
					sharpFlat = 0;
					isSharpChanged = true;
				}
				
				if (!isSharpChanged){
				
					//register
					if ((upperText > 71) && (upperText < 81))
					{
						register = (register < 4)? register + 1 : register;
					} else if ((upperText > 80) && (upperText < 91)) {
						register = (register > 0)? register - 1 : register;
					}
				}
				
			}
			
			var s:String;
			var pattern:RegExp = new RegExp("/\n\r");
			//add to the output
			txtInput.appendText(letter);
			if (_text == 13) {
				txtInput.appendText("\n\r");
			}
			if (txtInput.textHeight > ((stage.stageHeight / 4)*3)) {
				s = txtInput.getLineText(0);

				if (s.search(pattern)) {
					txtInput.text = txtInput.text.replace(pattern, "");
				}
				txtInput.replaceText(0, txtInput.getLineLength(1), "");

			}
			trace(txtInput.textHeight);
			//txtInput.appendText(" ["+String((txtInput.textHeight+","+ ((stage.stageHeight / 4)*3)))+"] ");
			
			//show the info
			movNoteInfo.setText("volume", String(volume));
			movNoteInfo.setText("note", note);
			movNoteInfo.setText("register", String(register));
			
			//stats
			/*movStats.addStat("vol", String(volume));
			movStats.addStat("key", key);
			movStats.addStat("reg", String(register));
			movStats.addStat("note", note);*/
			
		}
		
		private function playNote():void 
		{
			var sndNote:Sound;
			var tmpEvelope:ADSREnvelope;
			var tmpChannel:SoundChannel;
			
			var a:Number = 0;
			var r:Number = 0;
			
			//play the note
			sndNote = noteBin[register][note];
			//trace(sndNote.length);
			//tnsVolume.volume = volume;

			//tmpEvelope.sndTransform = tnsVolume;
			
			if (isSlur) {
				a = 1000;
				r = 2500;
			} else {
				a = 0;
				r = 1500;
			}
			
			if (isStaccato) {
				r = 250;
			}
			
			tmpEvelope = new ADSREnvelope(a, 0, 0, r);
			
			tmpEvelope.stage = stage;
			tmpEvelope.startEnvelope(sndNote, volume);
			
			//trace(System.totalMemory);
		}
		
		
	}
	
	
	
}