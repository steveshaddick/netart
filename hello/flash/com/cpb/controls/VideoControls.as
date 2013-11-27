package com.cpb.controls
{
	import com.cpb.buttons.FullscreenButton;
	import com.cpb.buttons.MuteButton;
	import com.cpb.buttons.PlayPauseButton;
	import com.cpb.controls.events.VideoControlsEvent;
	import com.cpb.controls.events.VideoScrubberEvent;
	import com.cpb.controls.events.VolumeEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Steve Shaddick
	 */
	public class VideoControls extends Sprite implements IVideoControllable
	{
		
		public var playPauseButton:PlayPauseButton;
		public var muteButton:MuteButton
		public var fullscreenButton:FullscreenButton;
		public var timeElapsed:TimeElapsed;
		
		public var controlsBG:Sprite;
		public var scrubber:VideoScrubber;
		public var volumeControl:IVolumeControllable;
		
		private var isMute:Boolean = false;
		private var isPaused:Boolean = false;
		private var isFullscreen:Boolean = false;
		
		public function VideoControls():void 
		{
			if (playPauseButton) {
				playPauseButton.addEventListener(MouseEvent.CLICK, playPauseClickHandler);
			}
			if (muteButton) {
				muteButton.addEventListener(MouseEvent.CLICK, muteClickHandler);
			}
			if (fullscreenButton) {
				fullscreenButton.addEventListener(MouseEvent.CLICK, fullScreenHandler);
			}
			if (volumeControl) {
				volumeControl.addEventListener(VolumeEvent.VOLUME_CHANGE, volumeChangeHandler);
				volumeControl.addEventListener(VolumeEvent.MUTE_ON, muteChangeHandler);
				volumeControl.addEventListener(VolumeEvent.MUTE_OFF, muteChangeHandler);
			}
			
			if (scrubber) {
				scrubber.addEventListener(VideoScrubberEvent.SCRUB_START, cloneScrubberHandler);
				scrubber.addEventListener(VideoScrubberEvent.SCRUB_MOVE, cloneScrubberHandler);
				scrubber.addEventListener(VideoScrubberEvent.SCRUB_END, cloneScrubberHandler);
			}
			
		}
		
		private function muteChangeHandler(e:VolumeEvent):void 
		{
			switch (e.type) 
			{
				case VolumeEvent.MUTE_ON:
					setMute(true);
					break;
					
				case VolumeEvent.MUTE_OFF:
					setMute(false);	
					break;
			}
		}
		
		private function volumeChangeHandler(e:VolumeEvent):void 
		{
			setMute(false);
			dispatchEvent(e.clone());
		}
		
		public function setWidth(w:Number):void 
		{
			/**
			 * determines how the controls scale horizontally, like for fullscreen
			 * this probably must be customized to fit the particular skin
			 */
			
			var xRatio:Number = w / controlsBG.width;
			var scrubWidth:Number;
			
			controlsBG.width = w;
			
			if (scrubber) {
				scrubWidth = xRatio * scrubber.currentWidth;
				scrubber.setWidth(scrubWidth);
			}
			
			var obj:DisplayObject;
			var middleX:Number = this.width / 2;
			for (var i:int = 0; i < this.numChildren; i++)
			{
				obj = getChildAt(i);
				if (obj.x > middleX) {
					obj.x *= xRatio;
				}
			}
		}
		
		public function setPositionSeconds(seconds:Number):void 
		{
			if (scrubber) {
				scrubber.setPositionSeconds(seconds);
			}
			if (timeElapsed) {
				timeElapsed.setElapsedSeconds(seconds);
			}
		}
		
		public function setTotalSeconds(seconds:Number):void 
		{
			if (scrubber) {
				scrubber.setTotalSeconds(seconds);
			}
			if (timeElapsed) {
				timeElapsed.setTotalSeconds(seconds);
			}
		}
		
		public function setPaused(paused:Boolean):void 
		{
			isPaused = paused;
			if (playPauseButton) {
				playPauseButton.setPlaying(!isPaused);
			}
		}
		
		public function setMute(mute:Boolean):void 
		{
			isMute = mute;
			if (muteButton) {
				muteButton.setMute(isMute);
			}
			if (isMute) {
				dispatchEvent(new VolumeEvent(VolumeEvent.MUTE_ON));
			} else {
				dispatchEvent(new VolumeEvent(VolumeEvent.MUTE_OFF));
			}
		}
		
		public function setFullscreen(fullscreen:Boolean):void 
		{
			isFullscreen = fullscreen;
			if (fullscreenButton) {
				fullscreenButton.setFullscreen(isFullscreen);
			}
			
		}
		
		public function show():void 
		{
			this.visible = true;
		}
		
		public function hide():void 
		{
			this.visible = false;
		}
		
		private function playPauseClickHandler(e:MouseEvent):void 
		{
			isPaused = !isPaused;
			if (playPauseButton) {
				playPauseButton.setPlaying(!isPaused);
			}
			if (isPaused) {
				dispatchEvent(new VideoControlsEvent(VideoControlsEvent.PAUSE));
			} else {
				dispatchEvent(new VideoControlsEvent(VideoControlsEvent.PLAY));
			}
		}
		
		private function cloneScrubberHandler(e:VideoScrubberEvent):void 
		{
			if (timeElapsed) {
				timeElapsed.setElapsedSeconds(e.seconds);
			}
			dispatchEvent(e.clone());
		}
		
		private function muteClickHandler(e:MouseEvent):void 
		{
			setMute(!isMute);
		}
		
		public function setLoaded(percent:Number):void 
		{
			if (scrubber) {
				scrubber.setLoaded(percent);
			}
		}
		
		private function fullScreenHandler(e:MouseEvent):void 
		{
			setFullscreen(!isFullscreen);
			if (isFullscreen) {
				dispatchEvent(new VideoControlsEvent(VideoControlsEvent.ENTER_FULLSCREEN));
			} else {
				dispatchEvent(new VideoControlsEvent(VideoControlsEvent.EXIT_FULLSCREEN));
			}
		}
		
	}
	
}