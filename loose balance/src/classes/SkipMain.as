package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import fl.video.FLVPlayback;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.display.StageDisplayState;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	* ...
	* @author Steve
	*/
	public class SkipMain extends MovieClip 
	{
		public var txtTitle:Sprite;
		public var loadingBar:Sprite;
		public var txtSorry:Sprite;
		
		
		private var movController:VideoController = new VideoController();
		//public var flvForward:FLVPlayback;
		
		
		private var nc:NetConnection = new NetConnection();
		private var nsPlay:NetStream;
		private var nsForward:NetStream;
		private var nsScrub:NetStream;
		
		private var vidPlay:Video = new Video (720, 480);
		private var vidForward:Video = new Video(720, 480);
		private var vidScrub:Video = new Video(720, 480);
		
		private var netClientPlay:Object = new Object();
		private var netClientForward:Object = new Object();
		private var netClientScrub:Object = new Object();
		
		private var tmrUpdatePlay:Timer;
		
		private var totalTime:Array = new Array();
		private var sprLoading:Sprite;
		
		private var tmrLoading:Timer;
		private var tmrSorry:Timer;
		private var isLoaded:Boolean = false;
		
		public function SkipMain():void 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			loadingBar.scaleX = 0;
			txtSorry.visible = false;
			
			tmrSorry = new Timer(15000, 1);
			tmrSorry.addEventListener(TimerEvent.TIMER, tmrSorryHandler);
			tmrSorry.start();
			
		}
		
		private function tmrSorryHandler(e:TimerEvent):void 
		{
			tmrSorry.removeEventListener(TimerEvent.TIMER, tmrSorryHandler);
			tmrSorry.stop();
			tmrSorry = null;
			
			if (txtSorry) {
				txtSorry.visible = true;
			}
		}
		
		private function timerLoadingHandler(e:TimerEvent):void 
		{
			var isLoaded:Boolean = true;
			if (nsScrub.bytesLoaded < nsScrub.bytesTotal) {
				isLoaded = false;
			}
			if (nsPlay.bytesLoaded < nsPlay.bytesTotal) {
				isLoaded = false;
			}
			if (nsForward.bytesLoaded < nsForward.bytesTotal) {
				isLoaded = false;
			}
			this.isLoaded = isLoaded;
			if (!isLoaded) {
				loadingBar.scaleX = ((nsScrub.bytesLoaded / nsScrub.bytesTotal) * 0.33) + ((nsPlay.bytesLoaded / nsPlay.bytesTotal) * 0.33) + ((nsForward.bytesLoaded / nsForward.bytesTotal) * 0.33);
				return;
			} else {
				if (txtSorry) {
					removeChild(txtTitle);
					txtTitle = null;
					removeChild(loadingBar);
					loadingBar = null;
					removeChild(txtSorry);
					txtSorry = null;
				}
			}
			
			
			if (tmrUpdatePlay == null) {
				tmrUpdatePlay = new Timer(100, 0);
				tmrUpdatePlay.addEventListener(TimerEvent.TIMER, updatePlayHandler);			
			}
			tmrLoading.stop();
			tmrLoading.removeEventListener(TimerEvent.TIMER, timerLoadingHandler);
			tmrLoading = null;
			
			tmrUpdatePlay.start();

			movController.visible = true;
			vidPlay.visible = true;
			nsPlay.resume();
		}
		
		
		private function stageHandler(_event:Event):void 
		{
			nc.connect(null);
			
			nsPlay = new NetStream(nc);
			nsForward = new NetStream(nc);
			nsScrub = new NetStream(nc);
			
			addChild(vidPlay);
			addChild(vidForward);
			addChild(vidScrub);
			
			vidPlay.attachNetStream(nsPlay);
			vidForward.attachNetStream(nsForward);
			vidScrub.attachNetStream(nsScrub);
			
			nsPlay.play("play.f4v");
			nsPlay.pause();
			nsPlay.seek(0);
			vidPlay.visible = false;
			//nsForward.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			nsForward.play("forward.flv");
			nsForward.pause();
			nsForward.seek(0);
			vidForward.visible = false;
			
			nsScrub.play("scrub.flv");
			nsScrub.pause();
			nsScrub.seek(0);
			vidScrub.visible = false;
			
			addChild(movController);
			movController.advanceLoaded(1);
			movController.addEventListener("onVolume", volumeHandler);
			movController.addEventListener("onMute", muteHandler);
			movController.addEventListener("onSeek", seekHandler);
			movController.addEventListener("onScrub", scrubHandler);
			movController.addEventListener("onScrubStop", scrubStopHandler);
			movController.addEventListener("onJump", jumpHandler);
			movController.addEventListener("onJumpStop", jumpStopHandler);
			
			movController.visible = false;
			
			netClientPlay.onMetaData = function(meta:Object) {
				totalTime['play'] = Number(meta.duration);
			}
			netClientForward.onMetaData = function(meta:Object) {
				totalTime['forward'] = Number(meta.duration);
			}
			netClientScrub.onMetaData = function(meta:Object) {
				totalTime['scrub'] = Number(meta.duration);
			}
			
			nsPlay.addEventListener(NetStatusEvent.NET_STATUS, netStatus); 
			nsForward.addEventListener(NetStatusEvent.NET_STATUS, netStatus); 
			nsScrub.addEventListener(NetStatusEvent.NET_STATUS, netStatus); 
			
			nsPlay.client = netClientPlay;
			nsForward.client = netClientForward;
			nsScrub.client = netClientScrub;
			
			movController.addEventListener("onPlay", mainPlayHandler);
			movController.addEventListener("onPause", mainPauseHandler);
			
			movController.setControlButton("play");
			
			tmrLoading = new Timer(100, 0);
			tmrLoading.addEventListener(TimerEvent.TIMER, timerLoadingHandler);
			tmrLoading.start();
			
			
			var numScale:Number = 1.5;
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			//stage.displayState = StageDisplayState.FULL_SCREEN; 
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//sprLoading = new Sprite();
			//sprLoading.graphics.beginFill(0xFFFFFF);
			//sprLoading.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			//loadingText = new LoadingText();
			//sprLoading.addChild(loadingText);
			//loadingText.x = stage.stageWidth / 2;
			//loadingText.y = stage.stageHeight / 2;
			//addChild(sprLoading);
			
			/*flvForward.autoPlay = false;
			flvForward.stop();
			flvForward.visible = false;
			
			flvPlay.autoPlay = false;
			flvPlay.play();
			
			trace(flvForward.playheadUpdateInterval);*/

			movController.resize(stage.stageWidth);
			movController.x = 0;
			movController.y = stage.stageHeight;
			
			
		}
		
		private function resizeHandler(_event:Event):void 
		{
			vidPlay.height = stage.stageHeight;
			vidPlay.width = stage.stageWidth;
			
			vidForward.height = stage.stageHeight;
			vidForward.width = stage.stageWidth;
			
			vidScrub.height = stage.stageHeight;
			vidScrub.width = stage.stageWidth;
			
			movController.resize(stage.stageWidth);
			movController.x = 0;
			movController.y = stage.stageHeight;
		}
		
		private function netStatusHandler(_event:NetStatusEvent):void 
		{
			trace(_event.info.code);
		}
		
		
		private function locatorHandler(_event:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			
			vidForward.visible = true;
			
			nsPlay.togglePause();
			vidPlay.visible = false;
			
			
		}
		
		private function mouseUpHandler(_event:MouseEvent):void 
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			nsForward.pause();
			vidForward.visible = false;
			
			trace("mouse up toggle");
			nsPlay.togglePause();
			vidPlay.visible =true;
		}
		
		private function mouseMoveHandler(_event:MouseEvent):void 
		{
			
			nsForward.seek(this.mouseX / 4);
			//movLocator.x = this.mouseX;
			
			_event.updateAfterEvent();
			//trace(flvForward.playheadTime +", "+(this.mouseX / 4));
		}
		
		private function updatePlayHandler(_event:TimerEvent):void 
		{
			movController.updatePlayPosition(nsPlay.time, totalTime['play']);
			//trace(nsPlay.time + " , " + totalTime['play']);
			if (nsPlay.time >= (totalTime['play']-0.1)) {
				reset();
			}
		}
		
		private function jumpHandler(_event:Event):void 
		{
			nsPlay.pause();
			vidPlay.visible = false;
			vidForward.visible = true;
			//nsForward.play();
		}
		
		private function jumpStopHandler(_event:Event):void 
		{
			//nsForward.pause();
			vidPlay.visible = true;
			vidForward.visible = false;
		}
		

		private function seekHandler(_event:Event):void 
		{
			nsForward.seek(movController.seekPerc * totalTime['forward']);
			nsPlay.seek(movController.seekPerc * totalTime['play']);
		}
		
		private function scrubHandler(_event:Event):void 
		{
			nsPlay.pause();
			vidPlay.visible = false;
			vidScrub.visible = true;
			
			nsScrub.seek(movController.scrubPerc * totalTime['scrub']);
			//trace(nsScrub.time+"   ,   "+totalTime['scrub']);
			nsPlay.seek(movController.scrubPerc * totalTime['play']);
			//trace(nsPlay.time + "   ,   " + totalTime['play']);
			//trace("----");
		}
		private function scrubStopHandler(_event:Event):void 
		{
			vidPlay.visible = true;
			vidScrub.visible = false;

		}
		
		private function mainPlayHandler(_event:Event):void 
		{
			if (!this.isLoaded) return;
			nsPlay.resume();
		}
		
		private function mainPauseHandler(_event:Event):void 
		{

			nsPlay.pause();
		}
		
		private function volumeHandler(_event:Event):void 
		{
			nsPlay.soundTransform = new SoundTransform(_event.target.percVolume);
		}
		private function muteHandler(_event:Event):void 
		{
			nsPlay.soundTransform = new SoundTransform(0);
		}
		
		private function netStatus(e:NetStatusEvent)
		{
			if (e.info.code == "NetStream.Seek.InvalidTime")
			{
				e.currentTarget.seek(e.info.details);
			}
		}  
		
		private function reset():void 
		{
			nsForward.pause();
			vidForward.visible = false;
			nsScrub.pause();
			vidScrub.visible = false;
			
			
			nsPlay.seek(0);
		}
	}
	
}