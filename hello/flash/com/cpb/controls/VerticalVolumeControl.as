package com.cpb.controls
{
	import com.cpb.controls.events.VolumeEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class VerticalVolumeControl extends Sprite implements IVolumeControllable
	{
		private static const CLOSED_HEIGHT:Number = 15;
		
		public var volumeBG:Sprite;
		public var volumeAmount:Sprite;
		
		private var volume:Number = 1;
		private var isMouseDown:Boolean = false;
		
		public function VerticalVolumeControl() 
		{
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			setVolume(1);
			height = CLOSED_HEIGHT;
			
		}
		
		public function setVolume(percent:Number):void 
		{
			percent = (percent > 1) ? 1 : percent;
			percent = (percent < 0) ? 0 : percent;
			
			volume = percent;
			volumeAmount.y = volumeBG.y + (volumeBG.height * (1 - volume));
			volumeAmount.height = volumeBG.height * volume;
		}
		
		private function changeVolume():void 
		{
			var percent:Number = mouseY / volumeBG.y;
			percent = (percent > 1) ? 1 : percent;
			percent = (percent < 0) ? 0 : percent;
			setVolume(percent);
			
			dispatchEvent(new VolumeEvent(VolumeEvent.VOLUME_CHANGE, percent));
		}
		
		private function close():void 
		{
			height = CLOSED_HEIGHT;
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, leaveHandler);
		}
		
		private function outHandler(e:MouseEvent):void 
		{
			if (!isMouseDown) {
				close();
			}
		}
		
		private function overHandler(e:MouseEvent):void 
		{
			scaleY = 1;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, leaveHandler);
			
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			isMouseDown = true;
			changeVolume();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			changeVolume();
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			var ptGlobal:Point = localToGlobal(new Point(mouseX, mouseY));
			
			isMouseDown = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			if (!hitTestPoint(ptGlobal.x, ptGlobal.y)) {

				close();
			}
		}
		
		private function leaveHandler(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			close();
		}
		
	}

}