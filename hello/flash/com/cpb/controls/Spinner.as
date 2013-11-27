package com.cpb.controls 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class Spinner extends Sprite
	{
		
		public var spinner:Sprite;
		public var speed:int = 10;
		
		public function Spinner() 
		{
			this.visible = false;
		}
		
		public function show():void 
		{
			if (this.visible) return;
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
			this.visible = true;
		}
		
		public function hide():void 
		{
			if (!this.visible) return;
			
			removeEventListener(Event.ENTER_FRAME, frameHandler);
			this.visible = false;
		}
		
		private function frameHandler(e:Event):void 
		{
			spinner.rotation += speed;
		}
		
	}

}