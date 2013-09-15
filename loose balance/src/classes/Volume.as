package classes
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import caurina.transitions.Tweener;
	
	/**
	* ...
	* @author Steve
	*/
	public class Volume extends MovieClip
	{
		
		public var movBG:MovieClip;
		public var movHorn:MovieClip;
		public var movBars:VolumeBars;
		public var movSlider:VolumeSlider;
		public var movHit:MovieClip;
		
		public var isMute:Boolean = false;
		public var isMouseOver:Boolean = false;
		public var isMouseDown:Boolean = false;
		
		private var tmrVolume:Timer;
		
		public function Volume():void 
		{
			//movBG.buttonMode = true;
			//this.mouseChildren = false;
			
			movHit.buttonMode = true;
			
			movHorn.mouseEnabled = false;
			movBars.mouseEnabled = false;			
			
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			movHit.addEventListener(MouseEvent.MOUSE_UP, hitUpHandler);
			movHit.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			movSlider.addEventListener("onVolume", volumeHandler);
			
			tmrVolume = new Timer(500, 1);
			tmrVolume.addEventListener(TimerEvent.TIMER, timerHandler);
			movSlider.y = -10;
			
		}
		
		public function setMute(_isMute:Boolean):void 
		{

			if (_isMute) {
				this.isMute = true;
				movHorn.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
				movBars.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
				movBG.rotation = 180;
				movSlider.setMute(true);
				movBars.setVolume(0);
				this.dispatchEvent(new Event("onMute",true));
			} else {
				this.isMute = false;
				movHorn.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 0, 0, 0);
				movBars.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 0, 0, 0);
				movBG.rotation = 0;
				movSlider.setMute(false);
				movBars.setVolume(movSlider.percVolume);
			}
		}
		
		public function openVolume():void 
		{
			Tweener.removeTweens(movSlider);
			Tweener.addTween(movSlider, {y: -75, time: 0.3, transition:"easeOutSine" } );
			
			movHorn.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
			movBars.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
			
		}
		
		public function closeVolume():void 
		{
			Tweener.removeTweens(movSlider);
			Tweener.addTween(movSlider, {y: -10, time: 0.3, transition:"easeOutSine" } );
			
			if (!this.isMute){
				movHorn.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
				movBars.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			}
		}
		
		public function setVolume(_percVolume:Number):void 
		{
			movSlider.setVolume(_percVolume);
		}
		
		private function rollOverHandler(_event:MouseEvent):void 
		{
			
			this.isMouseOver = true;
			tmrVolume.reset();
			openVolume();
			
		}
		
		private function rollOutHandler(_event:MouseEvent):void 
		{

			this.isMouseOver = false;

			if (!this.isMouseDown)
			{
				tmrVolume.reset();
				tmrVolume.start();
			}
			
		}
		
		private function hitUpHandler(_event:MouseEvent):void 
		{
			if (this.isMute) {
				setMute(false);
			} else {
				setMute(true);
			}
		}
		
		private function mouseDownHandler(_event:MouseEvent):void 
		{
			this.isMouseDown = true;
			movBG.rotation = 180;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
		}
		
		private function mouseUpHandler(_event:MouseEvent):void 
		{

			if (!this.isMouseOver) {
				
				movBG.rotation = 0;
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				closeVolume();
			}
			
			this.isMouseDown = false;
			
		}
		
		
		private function timerHandler(_event:TimerEvent):void 
		{
			closeVolume();
		}
		
		private function volumeHandler(_event:Event):void 
		{
			if (this.isMute) {
				this.isMute = false;
				movHorn.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 0, 0, 0);
				movBars.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 0, 0, 0);
				movBG.rotation = 0;
			}
			movBars.setVolume(movSlider.percVolume);
		}
	}
	
}