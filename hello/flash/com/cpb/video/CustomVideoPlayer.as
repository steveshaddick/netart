package com.cpb.video
{
	import com.cpb.controls.events.VideoControlsEvent;
	import com.cpb.controls.events.VideoScrubberEvent;
	import com.cpb.controls.events.VolumeEvent;
	import com.cpb.controls.IVideoControllable;
	import com.cpb.controls.Spinner;
	import com.cpb.video.events.VideoStreamEvent;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 		Steve Shaddick
	 * @version 	1.11
	 * @description A base class to use for playing flash video
	 * 				This is a wrapper class for the VideoStream class, the IVideoControllable interface and Spinner class
	 * @tags		video, flash, as3
	 */
	public class CustomVideoPlayer extends Sprite
	{
		public var videoStream:VideoStream;
		public var videoControls:IVideoControllable;
		public var spinner:Spinner;
		
		public var screenBG:Sprite;
		public var errorText:Sprite;
		public var autoHideTime:Number = 3000;
		
		private var wasPaused:Boolean = false;
		private var _autoHide:Boolean = false;
		private var wasAutoHide:Boolean = false;
		private var tmrMouse:Timer;
		
		private var ptControls:Point;
		private var originalScreenSize:Point;
		private var originalVideoPos:Point;
		
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		public function set autoHide(_autoHide:Boolean):void 
		{
			if (_autoHide){
				if (!this._autoHide) {
					tmrMouse = new Timer(autoHideTime, 1);
					tmrMouse.addEventListener(TimerEvent.TIMER, tmrMouseHandler);
					addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					tmrMouse.start();
				}
			} else {
				if (this._autoHide) {
					tmrMouse.stop();
					tmrMouse.removeEventListener(TimerEvent.TIMER, tmrMouseHandler);
					tmrMouse = null;
					removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					Mouse.show();
				}
				if (videoControls) {
					videoControls.show();
				}
			}
			this._autoHide = _autoHide;
		}
		
		
		/**
		* @function	CONSTRUCTOR
		* @input 	w (number) : Width
		* 			h (number) : Height
		* @description Creates a new CustomVideoPlayer object.
		*/
		public function CustomVideoPlayer() 
		{
			if (!screenBG) {
				screenBG = new Sprite();
				screenBG.graphics.beginFill(0x000000);
				screenBG.graphics.drawRect(0, 0, 320, 240);
				addChildAt(screenBG, 0);
			}
			
			if (videoControls) {
				var sprControls:Sprite = videoControls as Sprite;
				ptControls = new Point(sprControls.x, sprControls.y);
				
				videoControls.addEventListener(VideoControlsEvent.PLAY, playChangeHandler);
				videoControls.addEventListener(VideoControlsEvent.PAUSE, playChangeHandler);
				videoControls.addEventListener(VideoControlsEvent.ENTER_FULLSCREEN, fullScreenChangeHandler);
				videoControls.addEventListener(VideoControlsEvent.EXIT_FULLSCREEN, fullScreenChangeHandler);
				
				videoControls.addEventListener(VolumeEvent.MUTE_ON, muteChangeHandler);
				videoControls.addEventListener(VolumeEvent.MUTE_OFF, muteChangeHandler);
				videoControls.addEventListener(VolumeEvent.VOLUME_CHANGE, volumeChangeHandler);
				
				videoControls.addEventListener(VideoScrubberEvent.SCRUB_START, videoScrubberHandler);
				videoControls.addEventListener(VideoScrubberEvent.SCRUB_END, videoScrubberHandler);
				videoControls.addEventListener(VideoScrubberEvent.SCRUB_MOVE, videoScrubberHandler);
			}
			
			if (errorText) {
				errorText.visible = false;
			}
			
			autoHide = true;
			
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
		}
		
		public function openStream(ptSize:Point = null, connection:String = null):void 
		{
			ptSize = (!ptSize) ? new Point(320, 240) : ptSize;
			
			videoStream = new VideoStream(ptSize, connection);
			videoStream.screenWidth = screenBG.width;
			videoStream.screenHeight = screenBG.height;
			videoStream.x = screenBG.x;
			videoStream.y = screenBG.y;
			addChildAt(videoStream, getChildIndex(screenBG) + 1);
			
			videoStream.addEventListener(VideoStreamEvent.META_DATA, metaDataHandler);
			videoStream.addEventListener(VideoStreamEvent.PLAYHEAD_CHANGE, playheadChangeHandler);
			videoStream.addEventListener(VideoStreamEvent.LOAD_PROGRESS, loadProgressHandler);
			
			videoStream.addEventListener(VideoStreamEvent.BUFFER_EMPTY, bufferHandler);
			videoStream.addEventListener(VideoStreamEvent.BUFFER_FULL, bufferHandler);
			
			videoStream.addEventListener(VideoStreamEvent.PLAY_START, playVideoHandler);
			videoStream.addEventListener(VideoStreamEvent.PLAY_PAUSED, playVideoHandler);
			videoStream.addEventListener(VideoStreamEvent.PLAY_RESUMED, playVideoHandler);
			videoStream.addEventListener(VideoStreamEvent.VIDEO_COMPLETE, playVideoHandler);
			
			videoStream.addEventListener(VideoStreamEvent.ERROR, videoErrorHandler);
		}
		
		public function closeStream():void 
		{
			videoStream.close();
			
			videoStream.removeEventListener(VideoStreamEvent.META_DATA, metaDataHandler);
			videoStream.removeEventListener(VideoStreamEvent.PLAYHEAD_CHANGE, playheadChangeHandler);
			videoStream.removeEventListener(VideoStreamEvent.LOAD_PROGRESS, loadProgressHandler);
			
			videoStream.removeEventListener(VideoStreamEvent.BUFFER_EMPTY, bufferHandler);
			videoStream.removeEventListener(VideoStreamEvent.BUFFER_FULL, bufferHandler);
			
			videoStream.removeEventListener(VideoStreamEvent.PLAY_START, playVideoHandler);
			videoStream.removeEventListener(VideoStreamEvent.PLAY_PAUSED, playVideoHandler);
			videoStream.removeEventListener(VideoStreamEvent.PLAY_RESUMED, playVideoHandler);
			videoStream.removeEventListener(VideoStreamEvent.VIDEO_COMPLETE, playVideoHandler);
			
			videoStream.removeEventListener(VideoStreamEvent.ERROR, videoErrorHandler);
		}
		
		
		/**
		* @function	loadVideo
		* @input	url (string) : video file to load
		*			seek (number) : automatically jump to a particular time in seconds
		* @description 	Loads a new video file.
		*/
		public function loadVideo(url:String, seek:Number = 0):void 
		{
			if (spinner) {
				spinner.show();
			}
			if (errorText) {
				errorText.visible = false;
			}
			if (videoControls) {
				videoControls.setPositionSeconds(0);
			}
			videoStream.loadVideo(url, seek);
		}
		
		/**
		* @function	pauseVideo
		* @input	(none)
		* @description 	Pauses the video.
		*/
		public function pauseVideo():void {
			videoStream.pauseVideo();
		}
		
		/**
		* @function	playVideo
		* @input	(none)
		* @description 	Plays the video.
		*/
		public function playVideo():void {
			videoStream.resumeVideo();
		}
		
		
		/** Private functions **/
		
		private function stageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case Keyboard.SPACE:
					videoStream.togglePause();
					break;
			}
		}
		private function bufferHandler(e:VideoStreamEvent):void 
		{
			
			switch (e.type)
			{
				case VideoStreamEvent.BUFFER_EMPTY:
					if (!videoStream.isComplete) {
						if (spinner) {
							spinner.show();
						}
					}
					break;
					
				case VideoStreamEvent.BUFFER_FULL:
					if (spinner) {
						spinner.hide();
					}
					break;
			}
		}
		
		private function fullScreenChangeHandler(e:VideoControlsEvent):void 
		{
			var ptGlobal:Point;
			var sprControls:Sprite;
			var bounds:Rectangle;
			
			switch (e.type) 
			{
				case VideoControlsEvent.ENTER_FULLSCREEN:
					ptGlobal = localToGlobal(new Point(screenBG.x, screenBG.y));
					originalScreenSize = new Point(screenBG.width, screenBG.height);
					originalVideoPos = new Point(videoStream.x, videoStream.y);
					
					var monitorRatio:Number = stage.fullScreenWidth / stage.fullScreenHeight;
					var screenRatio:Number = screenBG.width / screenBG.height;
					
					if (monitorRatio > screenRatio) {
						screenBG.width = screenBG.height * monitorRatio;
					} else {
						screenBG.height = screenBG.width / monitorRatio;
					}
					
					videoStream.x = screenBG.x + ((screenBG.width - videoStream.screenWidth) / 2);
					videoStream.y = screenBG.y + ((screenBG.height - videoStream.screenHeight) / 2);
					
					stage.fullScreenSourceRect = new Rectangle(ptGlobal.x, ptGlobal.y, screenBG.width, screenBG.height);
					
					wasAutoHide = autoHide;
					autoHide = true;
					if (videoControls) {
						sprControls = videoControls as Sprite;
						bounds = sprControls.getRect(sprControls);
						
						sprControls.y = screenBG.y + screenBG.height - (bounds.height + bounds.y);
						sprControls.x = screenBG.x + ((screenBG.width - sprControls.width) / 2);
					}
					stage.displayState = StageDisplayState.FULL_SCREEN;
					stage.addEventListener(FullScreenEvent.FULL_SCREEN, stageFullScreenHandler);
					break;
					
				case VideoControlsEvent.EXIT_FULLSCREEN:
					stage.displayState = StageDisplayState.NORMAL;
					
					exitFullscreen();
					break;
			}
		}
		
		private function exitFullscreen():void 
		{
			var sprControls:Sprite;
			autoHide = wasAutoHide;
			screenBG.width = originalScreenSize.x;
			screenBG.height = originalScreenSize.y;
			originalScreenSize = null;
			
			videoStream.x = originalVideoPos.x;
			videoStream.y = originalVideoPos.y;
			originalVideoPos = null;			
			
			if (videoControls) {
				sprControls = videoControls as Sprite;
				sprControls.x = ptControls.x;
				sprControls.y = ptControls.y;
				
				videoControls.setFullscreen(false);
			}
			
			stage.fullScreenSourceRect = null;
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, stageFullScreenHandler);
		}
		
		private function loadProgressHandler(e:VideoStreamEvent):void 
		{
			if (videoControls) {
				videoControls.setLoaded(videoStream.percentLoaded);
			}
		}
		
		private function metaDataHandler(e:VideoStreamEvent):void 
		{
			var screenRatio:Number = screenBG.width / screenBG.height;
			var videoRatio:Number = videoStream.videoWidth / videoStream.videoHeight;
			var newWidth:Number;
			var newHeight:Number;
			
			if (screenRatio > videoRatio) {
				newHeight = screenBG.height;
				newWidth = newHeight * videoRatio;
			} else {
				newWidth = screenBG.width;
				newHeight = newWidth / videoRatio;
			}
			
			videoStream.x = screenBG.x + ((screenBG.width - newWidth) / 2);
			videoStream.y = screenBG.y + ((screenBG.height - newHeight) / 2);
			videoStream.setSize(newWidth, newHeight);
			
			if (videoControls) {
				videoControls.setTotalSeconds(videoStream.videoDuration);
			}
			if (errorText) {
				errorText.visible = false;
			}
		}
		
		private function muteChangeHandler(e:VolumeEvent):void 
		{
			switch (e.type) 
			{
				case VolumeEvent.MUTE_ON:
					videoStream.setMute(true);
					break;
					
				case VolumeEvent.MUTE_OFF:
					videoStream.setMute(false);
					break;
			}
			
		}
		
		private function playChangeHandler(e:VideoControlsEvent):void 
		{
			switch (e.type) 
			{
				case VideoControlsEvent.PLAY:
					videoStream.resumeVideo();
					break;
					
				case VideoControlsEvent.PAUSE:
					videoStream.pauseVideo();
					break;
			}
		}
		
		private function playheadChangeHandler(e:VideoStreamEvent):void 
		{
			if (videoControls) {
				videoControls.setPositionSeconds(videoStream.playheadTime);
			}
		}
		
		private function playVideoHandler(e:VideoStreamEvent):void 
		{
			if (errorText) {
				errorText.visible = false;
			}
			switch (e.type)
			{
				
				case VideoStreamEvent.PLAY_RESUMED:
					if (spinner) {
						spinner.hide();
					}
					//no break
				case VideoStreamEvent.PLAY_START:
					if (videoControls) {
						videoControls.setPaused(false);
					}
					dispatchEvent(e.clone());
					break;
					
				case VideoStreamEvent.PLAY_PAUSED:
					if (videoControls) {
						videoControls.setPaused(true);
					}
					break;
					
				case VideoStreamEvent.VIDEO_COMPLETE:
					if (spinner) {
						spinner.hide();
					}
					dispatchEvent(e.clone());
					break;
			}
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			Mouse.show();
			
			if (hitTestPoint(stage.mouseX, stage.mouseY)) {
				if (videoControls) {
					videoControls.show();
				}
				tmrMouse.reset();
				tmrMouse.start();
			}
		}
		
		private function stageFullScreenHandler(e:FullScreenEvent):void 
		{
			exitFullscreen();
		}
		
		private function tmrMouseHandler(e:TimerEvent):void 
		{
			if (hitTestPoint(stage.mouseX, stage.mouseY)) {
				Mouse.hide();
			}
			if (videoControls) {
				videoControls.hide();
			}
		}
		
		private function trackClickHandler(e:VideoScrubberEvent):void 
		{
			videoStream.seekTime(e.seconds);
		}
		
		private function videoErrorHandler(e:VideoStreamEvent):void 
		{
			if (videoControls) {
				videoControls.setPaused(true);
			}
			if (errorText) {
				errorText.visible = true;
			}
		}
		
		private function videoScrubberHandler(e:VideoScrubberEvent):void 
		{
			switch (e.type) {
				case VideoScrubberEvent.SCRUB_START:
					wasPaused = (videoStream.isPaused);
					videoStream.pauseVideo();
					videoStream.seekTime(e.seconds);
					break;
				
				case VideoScrubberEvent.SCRUB_END:
					videoStream.seekTime(e.seconds);
					if (!wasPaused) {
						videoStream.resumeVideo();
					}
					break;
					
				case VideoScrubberEvent.SCRUB_MOVE:
					videoStream.seekTime(e.seconds);
					break;
			}
		}
		
		private function volumeChangeHandler(e:VolumeEvent):void 
		{
			videoStream.setVolume(e.volume);
		}
		
	}

}