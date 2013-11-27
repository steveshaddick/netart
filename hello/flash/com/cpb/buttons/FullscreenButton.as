package com.cpb.buttons 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class FullscreenButton extends Sprite 
	{
		public var fullscreenSymbol:Sprite;
		public var smallscreenSymbol:Sprite;
		
		
		public function FullscreenButton() 
		{ 
			buttonMode = true;
			mouseChildren = false;
			
			setFullscreen(false);
		} 
		
		public function setFullscreen(isFullscreen:Boolean):void 
		{
			fullscreenSymbol.visible = !isFullscreen;
			smallscreenSymbol.visible = isFullscreen;
		}
		
	}
	
}