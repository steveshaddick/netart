package com.cpb.utils
{
	
	/**
	 * ...
	 * @author Steve Shaddick
	 * @version 1.0
	 */
	public class StringUtils 
	{
		public static const ALPHA_NUMERIC:String = "A-Za-z0-9";
		public static const ACCENTED_CHARACTERS:String = "ÂÃÄÀÁÅÆÇÈÉÊËÌÍÎÏÐÑŒÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöœøùúûüýþÿ";
		public static const COMBINED:String = ALPHA_NUMERIC + ACCENTED_CHARACTERS;
		public static const NAME_SYMBOLS:String = " \\-\\'\\.";
		public static const NAME_CHARACTERS:String = COMBINED + NAME_SYMBOLS;
		
		public static const EMAIL_CHARACTERS:String = "A-Za-z0-9@." + "&+=_\\-";
		public static const EMAIL_ALL_CHARACTERS:String = "A-Za-z0-9@." + "!#$%&'*+/=?_`{|}~\"\\-\\^";
		
		public function StringUtils():void 
		{
			
		}
		
		public static function lTrim(str:String):String
		{
			return str.replace(/^[ \s]+/, '');
		}
		
		public static function rTrim(str:String):String
		{
			return str.replace(/[ \s]+$/, '');
		}
		
		public static function trim(str:String):String 
		{
			str = lTrim(str);
			str = rTrim(str);
			
			return str;
		}
		
		public static function toTitleCase(str:String, exceptWords:Array = null):String 
		{
			var words:Array = str.split(" ");
			var hyphen:String;
			var hyphens:Array;
			
			var newHyphens:Array = new Array();
			var newWords:Array = new Array();
			var endSpace:String = (str.charAt(str.length - 1) == " ") ? " " : "";
			
			if (!exceptWords) {
				exceptWords = [];
			}
			
			var isSkip:Boolean = false;
			for each (var word:String in words)
			{
				word = word.toLowerCase();
				isSkip = false;
				for each (var exceptWord:String in exceptWords)
				{
					if (word == exceptWord) {
						isSkip = true;
						break;
					}
				}
				
				if ((word != "") && (!isSkip))
				{
						
					if (word.indexOf("-") > -1)
					{
						hyphens = word.split("-");
						
						for each (hyphen in hyphens)
						{
							if (hyphen.substr(0, 2) == "mc")
							{
								hyphen = hyphen.substr(0, 2) + hyphen.substr(2, 1).toUpperCase() + hyphen.substr(3);
							}
							
							hyphen = hyphen.substr(0, 1).toUpperCase() + hyphen.substr(1);
							newHyphens.push(hyphen);
						}
						
						word = newHyphens.join("-");
					}
					else if (word.indexOf("'") > -1)
					{
						hyphens = word.split("'");
						
						for each (hyphen in hyphens)
						{
							if (hyphen.substr(0, 2) == "mc")
							{
								hyphen = hyphen.substr(0, 2) + hyphen.substr(2, 1).toUpperCase() + hyphen.substr(3);
							}
							
							hyphen = hyphen.substr(0, 1).toUpperCase() + hyphen.substr(1);
							newHyphens.push(hyphen);
						}
						
						word = newHyphens.join("'");
					}
					else
					{
						if (word.substr(0, 2) == "mc")
						{
							word = word.substr(0, 2) + word.substr(2, 1).toUpperCase() + word.substr(3);
						}
						
						word = word.substr(0, 1).toUpperCase() + word.substr(1);
					}
				
					newWords.push(word);
					
				} else {
					if (word != "") {
						newWords.push(word);
					}
				}

			}
			
			return newWords.join(" ") + endSpace;
		}
		
		public static function formatSeconds(seconds:Number, format:String = "m:ss"):String 
		{
			var milliseconds:Number = Math.round(seconds * 1000);
			
			var time:Date = new Date(milliseconds);
			
			var isHoursZero:Boolean = (format.indexOf("hh") > -1);
			var isMinutesZero:Boolean = (format.indexOf("mm") > -1);
			
			var str:String = format;
			var strHours:String = ((time.hoursUTC < 10) && (isHoursZero)) ? "0" + String(time.hoursUTC) : String(time.hoursUTC);
			var strMinutes:String = ((time.minutesUTC < 10) && (isMinutesZero)) ? "0" + String(time.minutesUTC) : String(time.minutesUTC);
			var strSeconds:String = (time.secondsUTC < 10) ? "0" + String(time.secondsUTC) : String(time.secondsUTC);
			
			str = (isHoursZero) ? str.replace("hh", strHours) :  str.replace("h", strHours);
			str = (isMinutesZero) ? str.replace("mm", strMinutes) :  str.replace("m", strMinutes);
			str = str.replace("ss", strSeconds);
			
			return str;
			
		}
	}
	
}