package com.cpb.controls 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class TimeElapsed extends Sprite
	{	
		public var txtElapsedTime:TextField;
		public var timeFormat:String = "m:ss";
		public var textFormat:String = "$time / $total";
		
		private var totalSeconds:String = "0:00";
		
		public function TimeElapsed() 
		{
			if (!txtElapsedTime) {
				txtElapsedTime = new TextField();
				txtElapsedTime.text = textFormat;
				addChild(txtElapsedTime);
			}
			
			textFormat = txtElapsedTime.text;
			setElapsedSeconds(0);
		}
		
		public function setTotalSeconds(seconds:Number):void 
		{
			totalSeconds = formatSeconds(seconds, timeFormat);
			
			setElapsedSeconds(0);
		}
		
		public function setElapsedSeconds(seconds:Number):void 
		{
			var elapsedSeconds:String = formatSeconds(seconds, timeFormat);
			var str:String;
			str = textFormat.replace("$total", totalSeconds);
			str = str.replace("$time", elapsedSeconds);
			txtElapsedTime.text = str;
		}
		
		private function formatSeconds(seconds:Number, format:String = "m:ss"):String 
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