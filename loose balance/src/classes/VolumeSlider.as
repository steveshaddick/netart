package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	
	/**
	* ...
	* @author Steve
	*/
	public class VolumeSlider extends MovieClip
	{
		
		public var movTab:MovieClip;
		public var movSliderBar:MovieClip;
		public var movHit:MovieClip;
		
		public var percVolume:Number = 1;
		public var isMute:Boolean = false;
		
		private var tabBounds:Rectangle = new Rectangle(0, 10, 0, 44);
		
		public function VolumeSlider():void 
		{
			movTab.buttonMode = true;
			movSliderBar.buttonMode = true;
			
			movTab.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			movSliderBar.addEventListener(MouseEvent.MOUSE_UP, barUpHandler);
			
		}
		
		public function setMute(_isMute:Boolean):void 
		{
			isMute = _isMute;
			
			if (isMute) {
				Tweener.removeTweens(movTab);
				Tweener.addTween(movTab, { y:(tabBounds.y + tabBounds.height), time:0.3, transition:"easeOutSine" } );
			} else {
				setVolume();

			}
		}
		
		public function setVolume(_percVolume:Number = -1):void 
		{
			if (_percVolume != -1) {
				percVolume = _percVolume;
			}
			Tweener.removeTweens(movTab);
			Tweener.addTween(movTab, { y:(tabBounds.height - (percVolume * tabBounds.height) + tabBounds.y), time:0.3, transition:"easeOutSine" } );
			this.dispatchEvent(new Event("onVolume",true));
		}

		
		private function mouseDownHandler(_event:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			movTab.startDrag(false, tabBounds);
		}
		
		private function mouseUpHandler(_event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			movTab.stopDrag();
		}
		
		private function mouseMoveHandler(_event:MouseEvent):void 
		{
			percVolume = 1 - ((movTab.y - tabBounds.y) / tabBounds.height);
			this.isMute = false;
			this.dispatchEvent(new Event("onVolume",true));
		}
		
		private function barUpHandler(_event:MouseEvent):void 
		{
			
			percVolume = 1- ((mouseY - movSliderBar.y) / movSliderBar.height);
			setVolume();
			
		}
	}
	
}