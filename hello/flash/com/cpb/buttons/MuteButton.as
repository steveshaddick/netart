package com.cpb.buttons 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class MuteButton extends Sprite 
	{
		
		public var muteOn:Sprite;
		public var muteOff:Sprite;
		
		public function MuteButton() 
		{ 
			buttonMode = true;
			mouseChildren = false;
			
			setMute(false);
		} 
		
		public function setMute(isMute:Boolean):void 
		{
			muteOn.visible = isMute;
			muteOff.visible = !isMute;
		}
		
	}
	
}