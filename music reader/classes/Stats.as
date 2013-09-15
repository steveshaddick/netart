package classes
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import steve.utils.meMath3;
	
	/**
	* ...
	* @author Steve
	*/
	public class Stats extends MovieClip
	{
		public var txtKey1:TextField;
		public var txtKey2:TextField;
		public var txtKey3:TextField;
		public var txtKey4:TextField;
		public var txtKey5:TextField;
		public var txtKey6:TextField;
		public var txtKey7:TextField;
		public var txtKey8:TextField;
		public var txtKey9:TextField;
		public var txtKey10:TextField;
		public var txtKey11:TextField;
		public var txtKey12:TextField;
		
		public var txtReg1:TextField;
		public var txtReg2:TextField;
		public var txtReg3:TextField;
		public var txtReg4:TextField;
		public var txtReg5:TextField;
		
		public var txtVol:TextField;
		
		public var txtNote1:TextField;
		public var txtNote2:TextField;
		public var txtNote3:TextField;
		public var txtNote4:TextField;
		public var txtNote5:TextField;
		public var txtNote6:TextField;
		public var txtNote7:TextField;
		public var txtNote8:TextField;
		public var txtNote9:TextField;
		public var txtNote10:TextField;
		public var txtNote11:TextField;
		public var txtNote12:TextField;
		
		private var allStats:Array;
		private var totalNotes:Number = 0;
		
		public function Stats():void 
		{
			var i:int;
			
			allStats = new Array();
			
			allStats['key'] = new Array();
			for (i= 0; i <= 12; i++)
			{
				allStats['key'][i] = 0;
			}
			
			allStats['reg'] = new Array();
			for (i= 0; i <= 4; i++)
			{
				allStats['reg'][i] = 0;
			}
			
			allStats['vol'] = new Array();
			allStats['vol'][0] = 0;
			
			allStats['note'] = new Array();
			for (i= 0; i <= 12; i++)
			{
				allStats['note'][i] = 0;
			}
		}
		
		public function addStat(_stat:String, _val:String):void 
		{
			var index:Number;
			var txtField:TextField;
			var txtName:String;
			var numHold:Number;
			
			switch (_stat) {
				case "key":
				case "note":
				switch (_val) {
					case "A":
					index = 0;
					break;
					case "A#":
					index = 1;
					break;
					case "B":
					index = 2;
					break;
					case "C":
					index = 3;
					break;
					case "C#":
					index = 4;
					break;
					case "D":
					index = 5;
					break;
					case "D#":
					index = 6;
					break;
					case "E":
					index = 7;
					break;
					case "F":
					index = 8;
					break;
					case "F#":
					index = 9;
					break;
					case "G":
					index = 10;
					break;
					case "G#":
					index = 11;
					break;
				}
				break;
				
				case "vol":
				index = 0;
				break;
				
				case "reg":
				index = Number(_val);
				break;
			}
			
			allStats[_stat][index]++;
			numHold = allStats[_stat][index];
			totalNotes ++;
			
			//convert to base 1
			index ++;
			
			switch (_stat)
			{
				case "key":
				txtName = "txtKey" + String(index);
				break;
				
				case "reg":
				txtName = "txtReg" + String(index);
				break;
				
				case "note":
				txtName = "txtNote" + String(index);
				break;
				
				case "vol":
				txtName = "txtVol";
				break;
			}
			
			txtField = TextField(this.getChildByName(txtName));
			
			txtField.text = meMath3.round((numHold / totalNotes), 3);
			txtField.appendText("%");
			
			
		}
	}
	
}