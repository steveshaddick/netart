package classes
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	* ...
	* @author Steve
	*/
	public class NameText extends MovieClip 
	{
		
		public var txtName:TextField;
		public var movBG:MovieClip;
		
		private var tmr:Timer = new Timer(3000, 1);
		private var isClose:Boolean = true;
		private var isTimer:Boolean = false;
		
		private var TEXT_BOX_HEIGHT:Number;
		
		public function NameText():void 
		{
			TEXT_BOX_HEIGHT = txtName.height;
			
			txtName.alpha = 0;
			txtName.height = 0;
			movBG.width = 0;
			
			tmr.addEventListener(TimerEvent.TIMER, timerHandler);
		}	
		
		public function setText(_name:String):void 
		{
			txtName.text = _name;
		}
		
		public function open():void 
		{
			Tweener.removeTweens(movBG);
			Tweener.removeTweens(txtName);
			
			isClose = false;
			isTimer = true;
			
			Tweener.addTween(movBG, { width:(txtName.textWidth + 10), time: 0.1 } );
			Tweener.addTween(txtName, { alpha:1, height:TEXT_BOX_HEIGHT, time: 1.5, delay:0.1 } );
			
			tmr.start();
			
		}
		
		public function close():void 
		{
			if (isTimer){
				isClose = true;
			} else {
				closeDown();
			}
			
			
			//trace("closing " + txtName.text);
			
		}
		
		private function timerHandler(_event:TimerEvent):void 
		{
			if (isClose) {
				closeDown();
			}
			isTimer = false;
		}
		
		private function closeDown():void 
		{
			Tweener.removeTweens(movBG);
			Tweener.removeTweens(txtName);
			
			Tweener.addTween(txtName, { alpha:0, height:0, time: 1} );
			Tweener.addTween(movBG, { width:0, time: 0.1, delay:0.25 } );
			isClose = false;
		}
	}
	
}