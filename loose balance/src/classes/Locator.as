package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.display.Stage;
	
	/**
	* ...
	* @author Steve
	*/
	public class Locator extends MovieClip 
	{
		public var movMiddle:MovieClip;
		
		public function Locator():void 
		{
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.buttonMode = true;
		
		}
		
		public function highlight(_isHighlight:Boolean):void 
		{
			if (_isHighlight) {
				movMiddle.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
			} else {
				movMiddle.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			}
		}
		

		private function mouseDownHandler(_event:MouseEvent):void 
		{
			highlight(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(_event:MouseEvent):void 
		{
			highlight(false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
	}
	
}