package com.cpb.controls
{
	import com.cpb.controls.events.VideoScrubberEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class VideoScrubber extends Sprite
	{
		
		public var trackBG:Sprite;
		public var trackLoaded:Sprite;
		public var trackPlayed:Sprite;
		public var playhead:Sprite;		
		
		private var trackHit:Sprite;
		private var playPercent:Number = 0;
		private var loadPercent:Number = 0;
		private var totalSeconds:Number = 0;
		
		private var playheadBounds:Rectangle = new Rectangle();
		

		public function get currentWidth():Number 
		{
			return trackBG.width;
		}
		
		
		public function VideoScrubber(w:Number = 320, h:Number = 20) 
		{
			if (!trackBG) {
				trackBG = new Sprite();
				trackBG.graphics.beginFill(0xAAAAAA);
				trackBG.graphics.drawRect(0, 0, w, h);
			}
			
			trackHit = new Sprite();
			trackHit.graphics.beginFill(0x00FF00, 0);
			trackHit.graphics.drawRect(0, 0, trackBG.width, trackBG.height);
			trackHit.x = trackBG.x;
			trackHit.y = trackBG.y;
			
			playheadBounds.x = trackHit.x + (playhead.width / 2);
			playheadBounds.width = trackHit.width - playhead.width;
			
			addChildAt(trackHit, getChildIndex(playhead) - 1);
			
			setPositionSeconds(0);
			setLoaded(0);
			
			addEventListener(MouseEvent.MOUSE_DOWN, trackDownHandler);
		}
		
		public function setLoaded(percent:Number):void 
		{
			loadPercent = percent;
			if (trackLoaded) {
				trackLoaded.width = percent * trackHit.width;
			}
		}
		
		public function setPositionSeconds(seconds:Number):void 
		{
			playPercent = (totalSeconds > 0) ? seconds / totalSeconds : 0;
			
			if (playhead) {
				playhead.x = playheadBounds.x + (playPercent * playheadBounds.width);
			}
			if (trackPlayed) {
				trackPlayed.width = playhead.x - trackPlayed.x;
			}
		}
		
		public function setWidth(w:Number):void 
		{
			//determines how the controls scale horizontally, like for fullscreen
			
			trackBG.width = trackHit.width = w;
			
			setPositionSeconds(playPercent);
			setLoaded(loadPercent);
			
		}
		
		public function setTotalSeconds(seconds:Number):void 
		{
			totalSeconds = seconds;
		}
		
		private function getSeconds():Number
		{
			var _seconds:Number = ((mouseX - trackHit.x) / trackHit.width) * totalSeconds;
			_seconds = (_seconds > totalSeconds) ? totalSeconds : _seconds;
			_seconds = (_seconds < 0) ? 0 : _seconds;
			
			return _seconds;
		}
		
		
		private function dragMoveHandler(e:MouseEvent):void 
		{
			var seconds:Number = getSeconds();
			setPositionSeconds(seconds);
			dispatchEvent(new VideoScrubberEvent(VideoScrubberEvent.SCRUB_MOVE, seconds));
		}
		
		private function dragFinishHandler(e:Event):void 
		{
			var seconds:Number = getSeconds();
			
			setPositionSeconds(seconds);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragMoveHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, dragFinishHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragFinishHandler);
			
			dispatchEvent(new VideoScrubberEvent(VideoScrubberEvent.SCRUB_END, seconds));
		}
		
		private function trackDownHandler(e:MouseEvent):void 
		{
			
			var seconds:Number = getSeconds();
			setPositionSeconds(seconds);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragMoveHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, dragFinishHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragFinishHandler);
			dispatchEvent(new VideoScrubberEvent(VideoScrubberEvent.SCRUB_START, seconds));
			
		}
		
	}

}