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
	public class Planet extends MovieClip
	{
		
		public var distance:Number = 0;
		public var degree:Number = 0;
		public var revSpeed:Number = 0;
		public var rotSpeed:Number = 0;
		public var movHit:MovieClip;
		public var movPlanet:MovieClip;
		public var nameText:NameText = new NameText();
		
		public var mom:Sprite;
		
		private var AU:Number = 1000;
		private var SUN_RADIUS:Number = 550;
		
		public var moons:Array;
		
		public function Planet():void 
		{
			moons = new Array();
			
			movHit.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			nameText.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			movHit.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			movHit.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			addChild(nameText);
		}
		
		public function setParams(_distance:Number, _revSpeed:Number, _rotSpeed:Number, _mom:Sprite, _name:String):void 
		{
			distance = (_distance * AU)+SUN_RADIUS;
			revSpeed = _revSpeed;
			rotSpeed = _rotSpeed;
			
			mom = new Sprite();
			
			nameText.setText(_name);
		}
		
		public function addMoon(_scale:Number, _distance:Number, _revSpeed:Number, _rotSpeed:Number, _name:String):void 
		{
			var tmpMoon:Moon = new Moon();
			
			tmpMoon.setParams(_scale, _distance, _revSpeed, _rotSpeed, this, _name);
			
			
			this.addChild(tmpMoon);
			
			moons.push(tmpMoon);
		}
		
		public function revolve():void 
		{
			movPlanet.rotation -= rotSpeed;
			
			this.x = distance * Math.cos((Math.PI * degree)/360);
			this.y = distance * Math.sin((Math.PI * degree)/360);
			
			degree -= revSpeed;
			//trace(degree);
			if (degree < -720) {
				degree = degree + 720;
			}
			
			for each (var moon in moons) 
			{
				moon.revolve();
			}
			
		}
		
		private function mouseDownHandler(_event:MouseEvent) {
			//trace(this.x + "," + this.y);
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