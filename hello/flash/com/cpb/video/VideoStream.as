package com.cpb.video
{
	import com.cpb.video.events.VideoStreamEvent;
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 		Steve Shaddick
	 * @version 	1.01
	 * @description A wrapper class for NetConnection, NetStream and Video.
	 * @tags		video, flash, as3
	 */
	public class VideoStream extends Sprite 
	{
		
		private static const MAX_BUFFER_COUNT:int = 10;
		
		public var video:Video;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		
		public var isPlaying:Boolean = false;	//a bit of a misnomer - means that the NetStream is "playing" (but the video itself might be paused)
		public var isPaused:Boolean = false;
		public var isLoading:Boolean = false;
		public var isComplete:Boolean = false;
		public var isBuffering:Boolean = false;
		
		private var infoObject:Object;
		
		private var tmr:Timer;
		private var lastTime:Number = 0;
		private var bufferCount:int = 0;
		
		private var isMute:Boolean = false;
		
		private var isConnected:Boolean = false;
		private var isRTMP:Boolean = false;
		private var isPlayStopped:Boolean = false;
		private var isSeeked:Boolean = false;
		private var hold:Object;
		
		private var stNormal:SoundTransform = new SoundTransform(1);
		private var stMute:SoundTransform = new SoundTransform(0);
		
		
		public function get screenHeight():Number
		{
			return (video) ? video.height : NaN;
		}
		public function set screenHeight(h:Number):void
		{
			if (video) {
				video.height = h;
			}
		}
		
		public function get screenWidth():Number
		{
			return (video) ? video.width : NaN;
		}
		public function set screenWidth(w:Number):void
		{
			if (video) {
				video.width = w;
			}
		}
		
		public function get videoWidth():Number
		{
			return (infoObject) ? infoObject.width : NaN;
		}
		public function get videoHeight():Number
		{
			return (infoObject) ? infoObject.height : NaN;
		}
		
		public function get playheadTime():Number 
		{
			return (ns) ? ns.time : NaN;
		}
		
		public function get playheadPercent():Number 
		{
			return ((ns) && (infoObject)) ? ns.time / infoObject.duration : NaN;
		}
		
		public function get videoDuration():Number 
		{
			return (infoObject) ? infoObject.duration : NaN;
		}
		
		public function get percentLoaded():Number
		{
			return (ns) ? ns.bytesLoaded / ns.bytesTotal: NaN;
		}
		
		public function get muteVolume():Number 
		{
			return stMute.volume;
		}
		public function set muteVolume(volume:Number):void 
		{
			stMute.volume = volume;
		}
		
		/**
		* @function	CONSTRUCTOR
		* @input 	w (number) : Width
		* 			h (number) : Height
		* @description Creates a new VideoStream object.
		*/
		public function VideoStream(ptSize:Point = null, connection:String = null)
		{
			ptSize = (!ptSize) ? new Point(320, 240) : ptSize;
			
			nc = new NetConnection();
			if (connection) {
				isRTMP = true;
			} else {
				isConnected = true;
			}
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			nc.connect(connection);
			
			video = new Video(ptSize.x, ptSize.y);
			video.smoothing = true;
			addChild(video);
			
		}
		
		private function netStatusHandler(e:NetStatusEvent):void 
		{
			if (e.info.code == "NetConnection.Connect.Success") {
				isConnected = true;
				if (hold) {
					loadVideo(hold.url, hold.seek);
					hold = null;
				}
			} else {
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ERROR));
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void 
		{
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ERROR));
		}
		
		/**
		* @function	close
		* @description Stops the video, closes all connections and removes event handlers.
		*/
		public function close():void 
		{
			
			isPlaying = false;
			isPaused = false;
			isLoading = false;
			isComplete = false;
			
			video.clear();
			
			ns.close();
			ns.removeEventListener(NetStatusEvent.NET_STATUS , onStatus);
			ns = null;
			
			nc.close();
			tmr.removeEventListener(TimerEvent.TIMER, tmrHandler);
			tmr.stop();
			tmr = null;
		}
		
		/**
		* @function	loadVideo
		* @input	url (string) : video file to load
		*			seek (number) : automatically jump to a particular point(default: 0)
		*/
		public function loadVideo(url:String, seek:Number = 0 ):void 
		{
			if ((!isConnected) && (isRTMP)){
				hold = { url:url, seek:seek };
				return;
			}
			
			isPlaying = false;
			isPaused = false;
			isComplete = false;
			video.clear();
			
			if (ns) {
				ns.close();
			} else {
				
				ns = new NetStream(nc);
				ns.client = {onMetaData:ns_onMetaData};
				ns.addEventListener(NetStatusEvent.NET_STATUS , onStatus);
				
				ns.bufferTime = (isRTMP) ? 1 : 5;

				ns.soundTransform = (isMute) ? stMute : stNormal;
				
				video.attachNetStream(ns);
			}

			isLoading = true;
			isBuffering = true;
			lastTime = 0;
			ns.play(url);
			ns.seek(seek);
			
			if (!tmr) {
				tmr = new Timer(100, 0);
				tmr.addEventListener(TimerEvent.TIMER, tmrHandler);
			} 
			tmr.start();
		}
		
		/**
		* @function	pauseVideo
		* @description Pauses the video.
		*/
		public function pauseVideo():void 
		{
			if (isPaused) return;
			
			ns.pause();
			isPaused = true;
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAY_PAUSED));
		}
		
		/**
		* @function	resumeVideo
		* @description Resumes the video.
		*/
		public function resumeVideo():void 
		{
			if (!isPaused) return;
			
			if (isComplete) {
				isComplete = false;
				ns.seek(0);
			}
			
			isPaused = false;
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAY_RESUMED));
			ns.resume();
		}
		
		/**
		* @function	seekPercent
		* @input		percent (number) : Time in percentage to seek to.
		* @description 	Seeks the video to the specified time as percentage of total running time.
		*/
		public function seekPercent(percent:Number):void 
		{
			var percentLoaded:Number = ns.bytesLoaded / ns.bytesTotal;
			percent = (percent > percentLoaded) ? percentLoaded : percent;
			
			isComplete = false;
			ns.seek(percent * videoDuration);
		}
		
		/**
		* @function	seekTime
		* @input		time (number) : Time in seconds to seek to.
		* @description 	Seeks the video to the specified time in seconds.
		*/
		public function seekTime(time:Number):void 
		{
			var percentLoaded:Number = ns.bytesLoaded / ns.bytesTotal;
			var percent = time / videoDuration;
			percent = (percent > percentLoaded) ? percentLoaded : percent;
			
			isComplete = false;
			ns.seek(percent * videoDuration);
		}
		
		/**
		* @function	setSize
		* @input		w (number) : width
		*				h (number) : height
		* @description 	Sets the video size - this will alter the video's dimensions.
		*/
		public function setSize(w:Number, h:Number):void 
		{
			video.width = w;
			video.height = h;
		}
		
		/**
		* @function	setMute
		* @input	mute (boolean) : Whether or not to mute the video.
		* @description Mutes or unmutes the video.
		*/
		public function setMute(mute:Boolean):void 
		{
			isMute = mute;
			ns.soundTransform = (isMute) ? stMute : stNormal;
		}
		
		/**
		* @function	setVolume
		* @input	vol (number) : Volume to set the video, between 0 and 1.
		* @description Sets the volume to the specified value.
		*/
		public function setVolume(vol:Number):void 
		{
			isMute = false;
			stNormal.volume = vol;
			ns.soundTransform = stNormal;
		}
		
		/**
		* @function	stopVideo
		* @description Stops the video, clears it and closes the NetStream.
		*/
		public function stopVideo():void 
		{
			isPlaying = false;
			isPaused = false;
			video.clear();
			ns.close();
			
		}
		
		/**
		* @function	togglePause
		* @description Pauses the video if it's playing, plays the video if it's paused.
		*/
		public function togglePause():void 
		{
			if (isPaused) {
				resumeVideo();
			} else {
				pauseVideo();
			}
		}
		
		private function ns_onMetaData(infoObject:Object):void 
		{
			this.infoObject = infoObject;
		    
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.META_DATA));
			
			isPlaying = true;
		}
		
		private function tmrHandler(e:TimerEvent):void 
		{
			if (isComplete) return;
			if (!isPlaying) return;
			
			if (isBuffering) {
				if (ns.time != lastTime) {
					if (isBuffering) {
						isBuffering = false;
						dispatchEvent(new VideoStreamEvent(VideoStreamEvent.BUFFER_FULL));
					}
				}
			} else {
				if (!isPaused) {
					if (ns.time == lastTime){
						bufferCount ++;
					} else {
						bufferCount = 0;
						dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAYHEAD_CHANGE));
					}
					if (bufferCount > MAX_BUFFER_COUNT) {
						if (!isBuffering) {
							isBuffering = true;
							dispatchEvent(new VideoStreamEvent(VideoStreamEvent.BUFFER_EMPTY));
						}
					} 
				}
				
			}
			
			if (isLoading) {
				if ((ns.bytesLoaded / ns.bytesTotal) == 1) {
					isLoading = false;
				} 
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.LOAD_PROGRESS));
			}
			
			lastTime = ns.time;
			
		}
		
		private function onStatus(e:NetStatusEvent):void {
			
			//trace("NET STREAM EVENT", e.info.code);
			//ExternalInterface.call("flashcall", e.info.code);
			if (e.info.level == "error") {
				isPaused = true;
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ERROR));
			}
			switch(e.info.code) {
				case "NetStream.Play.Stop":
					if (!isRTMP) {
						isComplete = true;
						pauseVideo();
						dispatchEvent(new VideoStreamEvent(VideoStreamEvent.VIDEO_COMPLETE));
					} else {
						isPlayStopped = true;
					}
					break;
				
				case "NetStream.Buffer.Empty":
					//doesn't work for http, for rtmp can be used to detect video completion
					if ((isRTMP) && (isPlayStopped)){
						pauseVideo();
						isComplete = true;
						dispatchEvent(new VideoStreamEvent(VideoStreamEvent.VIDEO_COMPLETE));
					}
					break;
				
				case "NetStream.Buffer.Full":
					//not helpful, unless maybe the video is hosted on rtmp
					break;
				
				case "NetStream.Play.Failed":
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ERROR));
					break;
				
				case "NetStream.Unpause.Notify":
					if (isSeeked) {
						isSeeked = false;
					}
				case "NetStream.Play.Start":
					//NOTE - the RTMP server sends a play.start after a seek notify	
					if (isRTMP) {
						if (isSeeked) {
							return;
						}
						isPlayStopped = false;
					}
					isPaused = false;
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAY_START));
					break;
				
				case "NetStream.Play.StreamNotFound":
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ERROR));
					break;
				
				case "NetStream.Connect.Failed":
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ERROR));
					break;
				
				case "NetStream.Seek.Notify":
					if (isRTMP) {
						isSeeked = true;
					}
					break;
			}
		}
		
		
	}
	
}