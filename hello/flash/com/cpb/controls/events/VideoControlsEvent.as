package com.cpb.controls.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class VideoControlsEvent extends Event 
	{
		public static const ENTER_FULLSCREEN:String = "enterFullscreen";
		public static const EXIT_FULLSCREEN:String = "exitFullscreen";
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		
		public function VideoControlsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new VideoControlsEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("VideoStreamEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}