package classes 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Steve
	 */
	public class SkipPreloader extends Sprite 
	{
		public var txtTitle:Sprite;
		public var loadingBar:Sprite;
		public var txtSorry:Sprite;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var ldr:Loader;
		
		private var fileCount:int = 0;
		
		private var video:Video;
		private var videoList:Array = new Array("play.f4v", "forward.flv", "scrub.flv");
		
		private var tmr:Timer;
		
		public function SkipPreloader() 
		{
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			loadingBar.scaleX = 0;
			txtSorry.visible = false;
			
			tmrSorry = new Timer(15000, 1);
			tmrSorry.addEventListener(TimerEvent.TIMER, tmrHandler);
			tmrSorry.start();
		}
		
		private function tmrHandler(e:TimerEvent):void 
		{
			tmr.removeEventListener(TimerEvent.TIMER, tmrHandler);
			tmr.stop();
			tmr = null;
			
			txtSorry.visible = true;
		}
		
		private function stageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldrCompleteHandler);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ldrProgressHandler);
			
			ldr.load(new URLRequest("SkipMain.swf"));
			
			
		}
		
		private function ldrProgressHandler(e:ProgressEvent):void 
		{
			loadingBar.scaleX = (e.bytesLoaded / e.bytesTotal) * ( 1 / 4);
		}
		
		private function ldrCompleteHandler(e:Event):void 
		{
			ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, ldrCompleteHandler);
			ldr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, ldrProgressHandler);
			
			nc = new NetConnection();
			nc.connect(null);
			
			nextVideo();
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		private function nextVideo():void 
		{
			if (videoList.length == 0) {
				videosLoaded();
				return;
			}
			
			ns = new NetStream(nc);
			ns.client = new Object();
			
			video = new Video(648, 480);
			
			ns.play(videoList[0]);
			ns.pause();
			ns.seek(0);
			
			fileCount ++;
			videoList.splice(0, 1);
		}
		
		private function frameHandler(e:Event):void 
		{
			
			if ((ns.bytesLoaded / ns.bytesTotal) < 1) {
				loadingBar.scaleX = ( fileCount / 4) + (ns.bytesLoaded / ns.bytesTotal) * ( 1 / 4);
			} else {
				nextVideo();
			}
		}
		
		private function videosLoaded():void 
		{
			ns.close();
			nc.close();
			
			ns = null;
			video = null;
			nc = null;
			
			removeChild(txtTitle);
			txtTitle = null;
			removeChild(loadingBar);
			loadingBar = null;
			removeChild(txtSorry);
			txtSorry = null;
			
			removeEventListener(Event.ENTER_FRAME, frameHandler);
			addChild(ldr.content);
		}
		
		
	}

}