package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	* ...
	* @author Steve
	*/
	public class Sun extends MovieClip 
	{
		public var movBody:MovieClip;
		public var nameText:NameText = new NameText();
		
		public function Sun():void 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			nameText.setText("The Sun");
			addChild(nameText);
			
		}
		public function rotate(_rotate:Number):void 
		{
			//movBody.rotation += _rotate;
		}
		
		private function mouseDownHandler(_event:MouseEvent) {

			this.dispatchEvent(new Event("onSun", true));
		}
		
		private function rollOverHandler(_event:MouseEvent) {
			
			this.dispatchEvent(new Event("overObject", true));
			
			
		}
		private function rollOutHandler(_event:MouseEvent) {
			
			this.dispatchEvent(new Event("outObject", true));
			
		}
	}
	
}