package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Steve
	*/
	public class Moon extends MovieClip 
	{
		public var distance:Number = 0;
		public var revSpeed:Number = 0;
		public var rotSpeed:Number = 0;
		public var degree:Number = 0;
		public var movMoon:MovieClip;
		public var nameText:NameText = new NameText();
		
		public var mom:Sprite;
		
		public var movHit:MovieClip;
		
		public function Moon():void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			nameText.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			addChild(nameText);
		}
		
		public function setParams(_scale:Number, _distance:Number, _revSpeed:Number, _rotSpeed:Number, _mom:Sprite, _name:String):void 
		{
			this.scaleX = _scale;
			this.scaleY = _scale;
			distance = _distance;
			revSpeed = _revSpeed * 0.20833;
			rotSpeed = _rotSpeed;
			
			mom = _mom;
			
			nameText.setText(_name);
		}
		
		public function revolve():void 
		{
			movMoon.rotation += rotSpeed;
			
			this.x = distance * Math.cos((Math.PI * degree)/360);
			this.y = distance * Math.sin((Math.PI * degree)/360);
			
			degree -= revSpeed;
			//trace(degree);
			if (degree < -720) {
				degree = degree + 720;
			}
			
		}
		
		private function mouseDownHandler(_event:MouseEvent):void 
		{
			this.dispatchEvent(new Event("onPlanet", true));
		}
		
		private function rollOverHandler(_event:MouseEvent) {
			
			this.dispatchEvent(new Event("overObject", true));
			
		}
		private function rollOutHandler(_event:MouseEvent) {
			
			this.dispatchEvent(new Event("outObject", true));
			
		}
	}
	
}