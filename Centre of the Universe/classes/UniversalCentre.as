package classes 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.display.StageDisplayState;
	import steve.utils.meMath3;
	import flash.events.MouseEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	
	/**
	* ...
	* @author Steve
	*/
	public class UniversalCentre extends MovieClip
	{
		public var movBG:MovieClip;
		
		public var movUniverse:Universe = new Universe();
		private var ptOffset:Point = new Point(0,0);
		
		private var distance:Number = 0;
		private var degree:Number = 0;
		private var revSpeed:Number = 0;
		
		private var centrePlanet:Sprite = new Sprite();
		private var momPlanet:Sprite = new Sprite();
		
		private var offsetOverride:Boolean = false;
		private var isDrag:Boolean = false;
		
		private var txtName:NameText;
		
		private var centreOffset:Point = new Point();
		private var canDrag:Boolean = true;
		
		private var tmrDrag:Timer = new Timer(250, 1);
		
		private var btnReset:ResetButton = new ResetButton();
		
		
		public function UniversalCentre():void 
		{
			//movBG.alpha = 0;
			
			this.addChild(movUniverse);
			this.addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			this.addEventListener("onPlanet", onPlanetHandler);
			this.addEventListener("onSun", onSunHandler);
			this.addEventListener("overObject", overObjectHandler);
			this.addEventListener("outObject", outObjectHandler);
			
			btnReset.addEventListener(MouseEvent.CLICK, resetHandler);
			
			
			movUniverse.addEventListener("onChangeCentre", centreHandler);
			
			tmrDrag.addEventListener(TimerEvent.TIMER, timerHandler);

			
		}
		
		private function stageHandler(_event:Event):void 
		{
			//trace(stage.stageWidth);
			movUniverse.x = stage.stageWidth / 2;
			movUniverse.y = stage.stageHeight / 2;
			
			/*movBG.x = stage.stageWidth / 2;
			movBG.y = stage.stageHeight / 2;
			movBG.width = stage.stageWidth;
			movBG.height = stage.stageHeight;*/
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			
			drawStars();
			
			movUniverse.scaleX = 0.25;
			movUniverse.scaleY = movUniverse.scaleX;
			
			addChild(btnReset);
			btnReset.x = stage.stageWidth;
			btnReset.y = stage.stageHeight;
			
			stage.showDefaultContextMenu = false;
			//trace(movUniverse.x);
		}
		
		private function centreHandler(_event:Event):void 
		{
			drawStars();
			
		}
		
		private function drawStars():void 
		{
			this.graphics.clear();
			for (var i:Number = 0; i < 5000; i++)
			{
				this.graphics.lineStyle(1, (meMath3.rand(999997, 1000000)/1000000)*0xFFFFFF);
				this.graphics.drawEllipse(meMath3.rand(-1000, stage.stageWidth+1000), meMath3.rand(-1500, stage.stageHeight+1000), meMath3.rand(1, 2), meMath3.rand(1, 2));
			}
		}
		
		private function resizeHandler(_event:Event):void 
		{
			//movUniverse.x = (stage.stageWidth / 2)- (ptOffset.x * movUniverse.scaleX);
			//movUniverse.y = (stage.stageHeight / 2) - (ptOffset.y * movUniverse.scaleY);
			
			movUniverse.x = (movUniverse.x)- (ptOffset.x * movUniverse.scaleX);
			movUniverse.y = (movUniverse.y)- (ptOffset.y * movUniverse.scaleY);
			//trace(movUniverse.x);
			drawStars();
			
			btnReset.x = stage.stageWidth - this.x;
			btnReset.y = stage.stageHeight - this.y;
		}
		
		private function resetHandler(_event:MouseEvent):void 
		{
			movUniverse.scaleX = 0.25;
			movUniverse.scaleY = movUniverse.scaleX;
			onSunHandler(null);
		}
		
		private function timerHandler(_event:TimerEvent):void 
		{
			this.startDrag();
				this.isDrag = true;
				trace(this.x +", " + this.y);
				btnReset.visible = false;
		}
		
		private function mouseWheelHandler(_event:MouseEvent):void 
		{
			if ((_event.delta < 0) && (movUniverse.scaleX > 0.0005)) {
				movUniverse.scaleX /= 1.5;
				this.resizeHandler(null);
				
				//trace(movUniverse.scaleX);
			} else if ((movUniverse.scaleX<64) && (_event.delta > 0)){
				movUniverse.scaleX *= 1.5;
				this.resizeHandler(null);
			}
			
			movUniverse.scaleY = movUniverse.scaleX;
			
			
		}
		
		private function mouseUpHandler(_event:MouseEvent):void 
		{
			tmrDrag.stop();
			if (offsetOverride) {
				this.offsetOverride = false;
				canDrag = true;
				return;
			}
			if (isDrag) {
				this.isDrag = false;
				this.stopDrag();
				btnReset.visible = true;
				if (this.x < -1000) this.x = -1000;
				if (this.x > 1000) this.x = 1000;
				if (this.y < -1000) this.y = -1000;
				if (this.y > 1000) this.y = 1000;
				btnReset.x = stage.stageWidth - this.x;
				btnReset.y = stage.stageHeight - this.y;
			} else {
				//var pt:Point = new Point(stage.mouseX, stage.mouseY);
			
				//ptOffset = movUniverse.globalToLocal(pt);
				//resizeHandler(null);
			}
			
			
			
			//trace("recentre");
			
		}
		
		private function onPlanetHandler(_event:Event) {
			
			this.offsetOverride = true;
			this.x = 0;
			this.y = 0;
			
			//trace(_event.target);
			this.centrePlanet = Sprite(_event.target);
			//trace(_event.target.mom);
			this.momPlanet = Sprite(_event.target.mom);
			
			this.addEventListener(Event.ENTER_FRAME, frameHandler);
			
			btnReset.x = stage.stageWidth - this.x;
			btnReset.y = stage.stageHeight - this.y;
		}
		
		private function frameHandler(_event:Event):void 
		{

			movUniverse.x = (stage.stageWidth / 2)-((momPlanet.x + centrePlanet.x)* movUniverse.scaleX);
			movUniverse.y = (stage.stageHeight / 2)-((momPlanet.y +centrePlanet.y)* movUniverse.scaleY);
			
			/*trace(momPlanet.x);
			trace(centrePlanet.x);
			trace(((momPlanet.x + centrePlanet.x) * movUniverse.scaleX));
			trace(movUniverse.x);
			trace("-----");*/

		}

		private function onSunHandler(_event:Event):void 
		{
			trace("onSun");
			this.x = 0;
			this.y = 0;
			this.removeEventListener(Event.ENTER_FRAME, frameHandler);
			movUniverse.x = stage.stageWidth / 2;
			movUniverse.y = stage.stageHeight / 2;
			
			centrePlanet = null;
			momPlanet = null;
			
			btnReset.x = stage.stageWidth - this.x;
			btnReset.y = stage.stageHeight - this.y;

		}
		
		private function overObjectHandler(_event:Event):void 
		{
			canDrag = false;
			var nameText:NameText = NameText(_event.target.nameText);
			var objTarget:Sprite = Sprite(_event.target);
			
			//nameText.x = (objTarget.mouseX);
			//nameText.y = (objTarget.mouseY);
			nameText.scaleX = (1 / movUniverse.scaleX)/objTarget.scaleX;
			nameText.scaleY = (1 / movUniverse.scaleY)/objTarget.scaleY;
			
			//trace("opening " + _event.target);
			nameText.open();
			
		}
		
		private function outObjectHandler(_event:Event):void 
		{
			canDrag = true;
			
			var nameText:NameText = NameText(_event.target.nameText);
			//trace("closing " + _event.target);
			nameText.close();
		}
		
		private function mouseDownHandler(_event:MouseEvent):void 
		{
			if (this.canDrag){
				tmrDrag.reset();
				tmrDrag.start();
				
			}
		}
		
	

	}
	
}