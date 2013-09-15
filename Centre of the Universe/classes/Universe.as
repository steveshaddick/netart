package classes 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Steve
	*/
	public class Universe extends MovieClip
	{
		public var movSun:MovieClip;
		public var movEarth:Planet;
		public var movVenus:Planet;
		public var movMercury:Planet;
		public var movMars:Planet;
		public var movJupiter:Planet;
		public var movSaturn:Planet;
		public var movUranus:Planet;
		public var movNeptune:Planet;
		
		private var paramObj:Object = { t:0 };
		private var tmr:Timer;
		private var ROTATE_TIME:Number = 10000;
		
		
		private var ptCentre:Point = new Point(0, 0);
		private var centreRadius:Number;
		
		private var planets:Array;
		
		private var canDrag:Boolean = true;
		
		public function Universe():void 
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			//this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			//tmr = new Timer(10, 0);
			//tmr.addEventListener(TimerEvent.TIMER, timerHandler);
			
			this.addEventListener(Event.ENTER_FRAME, timerHandler);
			
			addEventListener("overObject", overObjectHandler);
			addEventListener("outObject", outObjectHandler);
			
			
			this.buttonMode = true;
			
			//incAmount = incTop / 2;
			
			movMercury.setParams(0.4, 1.25, 0.55, this, "Mercury");
			movVenus.setParams(0.7, 0.75, -0.5, this, "Venus");
			movEarth.setParams(1, 0.5, 15, this, "Earth");
			movMars.setParams(1.5, 0.38, 12, this, "Mars");
			movJupiter.setParams(5.2, 0.05, 0, this, "Jupiter");
			movSaturn.setParams(9.5, 0.0166, 0, this, "Saturn");
			movUranus.setParams(19.6, 0.006, 0, this,"Uranus");
			movNeptune.setParams(30, 0.003, 0, this,"Neptune");
			
			movEarth.addMoon(1, 50, -24, 12, "The Moon");
			
			movJupiter.addMoon(1.04, 400, -26.25, 13, "Io");
			movJupiter.addMoon(0.85, 500, -13, 6.5, "Europa");
			movJupiter.addMoon(1.5, 575, -6.5, 3.2, "Ganymede");
			movJupiter.addMoon(1.38, 650, -3.25, 16, "Callisto");
			
			movSaturn.addMoon(0.10, 600, 14, -12, "Mimas");
			movSaturn.addMoon(0.15, 650, 8, -4, "Enceladus");
			movSaturn.addMoon(0.3, 725, 6, -3, "Tethys");
			movSaturn.addMoon(0.32, 750, 4.5, -2.25, "Dione");
			movSaturn.addMoon(0.45, 800, 2.5, -1.25, "Rhea");
			movSaturn.addMoon(1.5, 900, 0.83, -0.415, "Titan");
			movSaturn.addMoon(0.4, 1000, 0.16, -0.08, "Iapetus");
			
			movUranus.addMoon(0.14, 300, 10, -5, "Miranda");
			movUranus.addMoon(0.33, 350, 6, -3, "Ariel");
			movUranus.addMoon(0.35, 400, 3.5, -1.75, "Umbriel");
			movUranus.addMoon(0.45, 475, 1.5, -0.75,"Titania");
			movUranus.addMoon(0.43, 550, 1, -0.5, "Oberon");
			
			movNeptune.addMoon(0.78, 550, -2.5, 1.25, "Triton");
			
			planets = new Array();
			planets[0] = movMercury;
			planets[1] = movVenus;
			planets[2] = movEarth;
			planets[3] = movMars;
			planets[4] = movJupiter;
			planets[5] = movSaturn;
			planets[6] = movUranus;
			planets[7] = movNeptune;
			
			
			/*movSun.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			movSun.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			movSun.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);*/
			
			
			centreRadius = (Math.abs(ptCentre.x) > Math.abs(ptCentre.y))? ptCentre.x : ptCentre.y;
			
		}
		
		private function stageHandler(_event:Event):void 
		{
			movSun.x = 0;
			movSun.y = 0;
			
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			//tmr.start();
		}
		
		private function timerHandler(_event:Event):void 
		{
			
			//movSun.x = (sunRadius * Math.sin(Math.PI * incDegree / incAmount));
			//movSun.y = (sunRadius * Math.cos(Math.PI * incDegree / incAmount));
			
			movSun.rotate(300);
			
			for each (var planet:Planet in planets) {
				planet.revolve();
			}
			
			
			/*movEarth.x = 350 * Math.cos(Math.PI * incDegree / incAmount);
			movEarth.y = 350 * Math.sin(Math.PI * incDegree / incAmount);
			
			movVenus.x = 250 * Math.cos(Math.PI * incVenus / incAmount);
			movVenus.y = 250 * Math.sin(Math.PI * incVenus / incAmount);
			
			movMercury.x = 150 * Math.cos(Math.PI * incMercury / incAmount);
			movMercury.y = 150 * Math.sin(Math.PI * incMercury / incAmount);
			
			movMars.x = 500 * Math.cos(Math.PI * incMars / incAmount);
			movMars.y = 500 * Math.sin(Math.PI * incMars / incAmount);
			
			movMoon.x = movEarth.x + (50 * Math.cos(Math.PI * incMoon / incAmount));
			movMoon.y = movEarth.y + (50 * Math.sin(Math.PI * incMoon / incAmount));
			
			movEarth.rotation += 15;
			movVenus.rotation += 10;
			movMercury.rotation += 1;
			movMars.rotation += 8;*/
			
			//if (ptCentre.x > ptCentre.y)
			//this.x = ((stage.stageWidth / 2) - (centreRadius* Math.cos(Math.PI * 0 / 0)));
			//this.y = ((stage.stageHeight / 2) - (centreRadius* Math.sin(Math.PI * 0 / 0)));
			
			//this.x = (stage.stageWidth / 2) - ptCentre.x;
			//this.y = (stage.stageHeight / 2) - ptCentre.y;
			
			//this.rotation = Math.cos(Math.PI * 0 / 0);
			
			//trace(this.x);
			
		}
		
		private function outObjectHandler(_event:Event):void 
		{
			canDrag = true;
		}
		
		private function overObjectHandler(_event:Event):void 
		{
			canDrag = false;
		}
		
		
		
	}
	
}