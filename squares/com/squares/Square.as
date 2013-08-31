package com.squares
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author steve shaddick
	 */
	public class Square extends Sprite 
	{
		public static const DONE:String = "done";
		
		private var isDone:Boolean = false;
		
		public function Square(color:uint)
		{
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			graphics.beginFill(color);
			graphics.drawRect( -10, -10, 20, 20);
			
			this.scaleX = this.scaleY = 0.01;
		}
		
		private function stageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
			
		}
		
		public function close():void 
		{
			removeEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		private function frameHandler(e:Event):void 
		{
			if ((this.width > stage.stageWidth) && (this.height > stage.stageHeight)) 
			{
				if (!isDone) {
					dispatchEvent(new Event(DONE));
					isDone = true;
				}
				
				return;
			}
			
			this.scaleX *= 1.1;
			this.scaleY *= 1.1;
			
			
		}
		
		
	}
	
}