package classes
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import steve.utils.meMath3;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	* ...
	* @author Steve
	*/
	public class VideoController extends MovieClip 
	{
		public var movBG:MovieClip;
		public var movPlayPause:PlayPause;
		public var line1:MovieClip;
		public var line2:MovieClip;
		public var movLocator:Locator;
		public var movPosition:Position;
		public var txtTime:TextField;
		public var movVolume:Volume;
		
		public var originalWidth:Number = 640;
		
		public var minScale:Number = 0.75;
		public var maxScale:Number = 1.5;
		
		public var percPosition:Number = 0;
		public var percLoaded:Number = 0;
		
		public var lockLocatorToLoaded:Boolean = true;
		
		public var seekPerc:Number = 0;
		public var scrubPerc:Number = 0;
		
		public var jumpX:Array;
		
		private var locatorBounds:Rectangle = new Rectangle();
		private var isDragLocator:Boolean = false;
		private var startDragX:Number = 0;
		
		private var rightPosEdge:Number = 100;
		
		private var isScrub:Boolean = false;
		private var isJump:Boolean = false;
		public var isPlay:Boolean = false;
		
		private var tmrJump:Timer;
		
		public function VideoController():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			tmrJump = new Timer(100, 0);
			tmrJump.addEventListener(TimerEvent.TIMER, jumpTimerHandler);
			
			movLocator.addEventListener(MouseEvent.MOUSE_DOWN, locatorDownHandler);
			movPosition.addEventListener(MouseEvent.MOUSE_DOWN, positionDownHandler);
			movVolume.setVolume(1);
			
			movPlayPause.addEventListener("onPlay", playHandler);
			movPlayPause.addEventListener("onPause", pauseHandler);
			
		}
		
		public function resize(_width:Number):void 
		{
			var numScale:Number = _width/originalWidth;
			
			if (numScale < minScale)
			{
				numScale = minScale;
			}
			if (numScale > maxScale)
			{
				numScale = maxScale;
			}
			
			movBG.width = _width;
			movBG.scaleY = numScale;
			
			movBG.x = movBG.width/2;
			movBG.y = -movBG.height/2;
			
			movPlayPause.scaleX = numScale;
			movPlayPause.scaleY = numScale;
			
			movPlayPause.x = movPlayPause.width/2;
			movPlayPause.y = movBG.y;
			
			line1.scaleY = numScale;
			line1.y = 0;
			line1.x = movPlayPause.width;
			
			
			movVolume.scaleX = numScale;
			movVolume.scaleY = numScale;
			movVolume.y = movBG.y;
			movVolume.x = _width - (movVolume.width / 2);
			
			line2.scaleY = numScale;
			line2.y = 0;
			line2.x = _width - movVolume.width;

			txtTime.scaleX = numScale;
			txtTime.scaleY = numScale;
			txtTime.x = line2.x - txtTime.width - (5 * numScale);
			txtTime.y = movBG.y - (txtTime.height/2);
			
			
			movPosition.height = movBG.height/3;
			movPosition.x = line1.x +(movPosition.height * 1.25);
			movPosition.width = txtTime.x - movPosition.x;
			//trace((rightPosEdge * numScale));
			//trace(movPosition.width);
			movPosition.y = movBG.y;
			
			movLocator.scaleY = numScale;
			movLocator.scaleX = numScale;
			
			movLocator.y = movPosition.y;
			
			locatorBounds.x = movPosition.x;
			locatorBounds.width = movPosition.width * percLoaded;
			locatorBounds.y = movPosition.y;
			
			movLocator.x = (movPosition.width * percPosition) + movPosition.x;
			
			
		}
		
		public function advanceLoaded(_perc:Number):void 
		{
			percLoaded = _perc;
			locatorBounds.width = movPosition.width * percLoaded;
			movPosition.advanceLoaded(_perc);
		}
		
		public function updatePlayPosition(_pos:Number, _total:Number):void 
		{
			var strTime:String ="";
			
			percPosition = _pos/_total;
			
			updateLocator(percPosition);
			
			if (((_pos / 60) < 1) && (_total > 600))
			{
				strTime = "0";
			}
			
			strTime += Math.floor(_pos / 60);
			strTime += ":";
			if ((_pos % 60) < 10)
			{
				strTime += "0";
			}
			strTime += Math.floor(_pos % 60);
			strTime += " / ";
			strTime += Math.floor(_total / 60);
			strTime += ":";
			if ((_total % 60) < 10)
			{
				strTime += "0";
			}
			strTime += Math.floor(_total % 60);
			
			txtTime.text = strTime;
			
			
		}
		
		public function updateLocator(_perc:Number):void 
		{

			if (!isDragLocator){
				movPosition.advancePosition(_perc);
				movLocator.x = (locatorBounds.width * _perc)+locatorBounds.x;
			}
		}
		
		public function setControlButton(_button:String):void 
		{
			
			switch (_button)
			{
				case "play":
				movPlayPause.setPlay();
				//isPlay = true;
				break;
				
				case "pause":
				movPlayPause.setPause();
				//isPlay = false;
				break;
			}
			
			trace("isplay:" + this.isPlay);

		}
		
		private function stageHandler(_event:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, locatorUpHandler);
		}
		
		private function positionDownHandler(_event:MouseEvent):void 
		{
			isScrub = true;
			jumpX = new Array();
			jumpX[0] = movLocator.x;
			jumpX[1] = mouseX;
			this.dispatchEvent(new Event("onJump"));
			if (!isJump) {
				isJump = true;
				tmrJump.start();
			}
			
			//movLocator.highlight(true);
			//locatorDownHandler(null);
		}
		
		private function jumpTimerHandler(_event:TimerEvent):void 
		{
			var jumpAmount:Number = 50;
			
			if (!isJump) {
				tmrJump.stop();
			}
			
			if (Math.abs(jumpX[1] - jumpX[0]) < 50) {
				jumpX[0] = jumpX[1];
				isJump = false;
				tmrJump.stop();
				this.dispatchEvent(new Event("onJumpStop"));
				if (isPlay){
					this.dispatchEvent(new Event("onPlay"));
				}
			} else {
				if (jumpX[0] < jumpX[1]){
					jumpX[0] += jumpAmount;
				} else {
					jumpX[0] -= jumpAmount;
				}
			}
			
			movLocator.x = jumpX[0];
			seekPerc = (movLocator.x - movPosition.x) / movPosition.width;
			this.dispatchEvent(new Event("onSeek"));
			
		}
		
		private function locatorDownHandler(_event:MouseEvent):void 
		{
			isDragLocator = true;
			movLocator.startDrag(false, locatorBounds);
			startDragX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, locatorMoveHandler);
			
		}
		
		
		
		private function locatorUpHandler(_event:MouseEvent):void 
		{
			if (isDragLocator){
				seekPerc = (movLocator.x - movPosition.x) / movPosition.width;
				this.dispatchEvent(new Event("onSeek"));
				movLocator.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, locatorMoveHandler);
				isDragLocator = false;
				if (isPlay){
					this.dispatchEvent(new Event("onPlay"));
				}
				this.dispatchEvent(new Event("onScrubStop"));
				//movLocator.highlight(false);
			}
			
			if (isScrub) {
				this.dispatchEvent(new Event("onScrubStop"));
				movLocator.highlight(false);
			}
		}
		
		private function locatorMoveHandler(_event:MouseEvent):void 
		{
			scrubPerc = (movLocator.x - movPosition.x) / movPosition.width;
			this.dispatchEvent(new Event("onScrub"));
			updateLocator((movLocator.x - movPosition.x) / movPosition.width);
			//trace(movLocator.x);

			
		}
		
		private function playHandler(_event:Event):void 
		{
			this.isPlay = true;
		}
		
		private function pauseHandler(_event:Event):void 
		{
			this.isPlay = false;
		}

	}
	
}