package com.cpb.buttons 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class PlayPauseButton extends Sprite 
	{
		
		public var playSymbol:Sprite;
		public var pauseSymbol:Sprite;
		
		
		public function PlayPauseButton() 
		{ 
			buttonMode = true;
			mouseChildren = false;
			
			setPlaying(true);
		}
		
		public function setPlaying(isPlaying:Boolean):void 
		{
			playSymbol.visible = !isPlaying;
			pauseSymbol.visible = isPlaying;
			
		}
			
	}
	
}