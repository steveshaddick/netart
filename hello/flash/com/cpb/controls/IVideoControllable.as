package com.cpb.controls 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public interface IVideoControllable extends IEventDispatcher
	{
		
		function setWidth(w:Number):void;
		function setTotalSeconds(seconds:Number):void;
		function setPositionSeconds(seconds:Number):void;
		function setLoaded(percent:Number):void;
		function setPaused(paused:Boolean):void;
		function setMute(mute:Boolean):void;
		function setFullscreen(fullscreen:Boolean):void;
		function hide():void;
		function show():void;
		
	}
	
}