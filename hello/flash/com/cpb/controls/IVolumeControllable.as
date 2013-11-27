package com.cpb.controls
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public interface IVolumeControllable extends IEventDispatcher
	{
		function setVolume(volume:Number):void;
	}
	
}