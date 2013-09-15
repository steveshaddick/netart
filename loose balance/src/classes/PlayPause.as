package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	
	/**
	* ...
	* @author Steve
	*/
	public class PlayPause extends MovieClip
	{
		
		public var movBG:MovieClip;
		public var movPlay:MovieClip;
		public var movPause:MovieClip;
		
		private var isMouseOver:Boolean = false;
		private var isMouseDown:Boolean = false;

		
		public var isPlay = false;
		
		public function PlayPause():void 
		{
			this.buttonMode = true;
			this.mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			movPlay.visible = true;
			movPause.visible = false;
			
		}
		
		public function togglePlayPause():void 
		{
			movBG.rotation = 0;
			this.isMouseDown = false;
			
			//trace(this.isMouseOver);
			
			if (this.isMouseOver)
			{
				if (this.isPlay) 
				{
					setPause();
					
				} else {
					
					setPlay();
					
				}
				addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			} else {
				movPlay.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
				movPause.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			}
			
		}
		
		public function setPlay():void 
		{
			movPause.visible = true
			movPlay.visible = false;
			this.isPlay = true;
			this.dispatchEvent(new Event("onPlay",true));
		}
		
		public function setPause():void 
		{
			movPause.visible = false;
			movPlay.visible = true;
			this.isPlay = false;
			this.dispatchEvent(new Event("onPause",true));
		}
		
		private function rollOverHandler(_event:MouseEvent):void 
		{
			
			this.isMouseOver = true;
			
			
			movPause.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
			movPlay.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
		}
		
		private function rollOutHandler(_event:MouseEvent):void 
		{

			this.isMouseOver = false;
			
			//trace("out");
			
			if (!this.isMouseDown)
			{
				movPlay.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
				movPause.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
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
			togglePlayPause();
			
		}
	}
	
}