package com.cpb.controls.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class VolumeEvent extends Event 
	{
		public static const VOLUME_CHANGE:String = "volumeChange";
		public static const MUTE_ON:String = "muteOn";
		public static const MUTE_OFF:String = "muteOff";
		
		public var volume:Number;
		
		public function VolumeEvent(type:String, volume:Number = NaN, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.volume = volume;
		} 
		
		public override function clone():Event 
		{ 
			return new VolumeEvent(type, volume, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("VolumeEvent", "type", "volume", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}