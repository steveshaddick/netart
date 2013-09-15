package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Steve
	*/
	public class ResetButton extends MovieClip
	{
		public var movSun:MovieClip;
		
		public function ResetButton():void 
		{
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			
			movSun.stop();
			this.buttonMode = true;
			this.mouseChildren = false;
			movSun.visible = false;
		}
		
		private function rollOutHandler(_event:MouseEvent):void 
		{
			movSun.stop();
			movSun.visible = false
		}
		
		private function rollOverHandler(_event:MouseEvent):void 
		{
			movSun.gotoAndPlay(1);
			movSun.visible = true;
		}
	}
	
}