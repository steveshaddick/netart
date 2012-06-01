package com.colourbars
{
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Steve
	 */
	public class ColourBars extends Sprite
	{
		
		private var tintBars:Vector.<ChangingBar> = new Vector.<ChangingBar>();
		private var tmr:Timer;
		private var isRevert:Boolean = false;
		
		public function ColourBars()
		{
			TweenPlugin.activate([TintPlugin]);
			
			var i:int;
			for (i = 1; i <= 12; i++)
			{
				ChangingBar(this['changeBar_' + i]).changeWidth();
			}
			
			var obj:DisplayObject;
			for (i = 0; i < numChildren; i++) {
				obj = getChildAt(i);
				if (obj is ChangingBar) {
					tintBars.push(obj);
					ChangingBar(obj).changeTint();
				}
			}
			
			tmr = new Timer(500, 0);
			tmr.addEventListener(TimerEvent.TIMER, tmrHandler);
			tmr.start();
			
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
		}
		
		private function tmrHandler(e:TimerEvent):void 
		{
			var date:Date = new Date();
			var i:int;
			var tintBar:ChangingBar;
			
			if ((date.seconds >= 50) && (!isRevert)){
				isRevert = true;
				for each (tintBar in tintBars) {
					tintBar.revert();
				}
			} else if ((date.seconds == 0) && (isRevert)) {
				isRevert = false;
				for (i = 1; i <= 12; i++)
				{
					ChangingBar(this['changeBar_' + i]).changeWidth();
				}
				for each (tintBar in tintBars) {
					tintBar.changeTint();
				}
			}
		}
		
		private function stageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP;
			
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			
		}
	
	}

}