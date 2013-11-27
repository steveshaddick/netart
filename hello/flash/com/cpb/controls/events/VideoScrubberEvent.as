package com.cpb.controls.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class VideoScrubberEvent extends Event 
	{
		public static const SCRUB_START:String = "scrubStart";
		public static const SCRUB_END:String = "scrubEnd";
		public static const SCRUB_MOVE:String = "scrubMove";
		
		public var seconds:Number;
		
		public function VideoScrubberEvent(type:String, seconds:Number = NaN, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.seconds = seconds;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new VideoScrubberEvent(type, seconds, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("VideoStreamEvent", "seconds", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}