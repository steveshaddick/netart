package com.squares
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author steve shaddick
	 */
	public class NonSquare extends Sprite 
	{
		public static const DONE:String = "done";
		
		private var isDone:Boolean = false;
		private var size:Number = 0;
		private var isRotate:Boolean = false;
		private var rotationAmount:Number = 0;
		
		public function NonSquare(color:uint)
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
			
			this.x = (stage.stageWidth / 2) - (this.width / 2);
			this.y = (stage.stageHeight / 2) - (this.height / 2);
			
			size = (stage.stageWidth > stage.stageHeight) ? Math.random() * (stage.stageWidth + 50) : Math.random() * (stage.stageHeight + 50);
			
			if (Math.random() < 0.5) {
				rotationAmount = (-0.5 + (Math.random()))/10;
				
			}
			
		}
		
		public function close():void 
		{
			removeEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		private function frameHandler(e:Event):void 
		{
			if ((this.width > size) && (this.height > size)) 
			{
				//trace(this.width, this.height , size);
				if (!isDone) {
					dispatchEvent(new Event(DONE));
					isDone = true;
				}
				
				return;
			}
			
			this.scaleX *= 1.05;
			this.scaleY *= 1.05;
			
			if (rotationAmount != 0) {
				this.rotation += rotationAmount;
			}
			
		}
		
		
	}
	
}