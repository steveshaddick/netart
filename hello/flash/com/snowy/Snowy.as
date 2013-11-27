package com.snowy 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Steve
	 */
	public class Snowy extends Sprite
	{
		const UNIT:int = 15;
		
		const BETWEEN_PART:int = UNIT;
		const DOT:int = UNIT;
		const DASH:int = UNIT * 3;
		const BETWEEN_LETTER:int = UNIT * 3;
		const SPACE:int = UNIT * 7;
		
		public var pixels:Vector.<Pixel>= new Vector.<Pixel>();
		public var screenPixels:Vector.<uint> = new Vector.<uint>(2073600, true);
		public var rect:Rectangle = new Rectangle(0, 0, 1920, 1080);
		public var count:int = 0;
		public var maxOn:int = 0;
		public var maxHold:int = 0;
		public var letters:Array;
		public var bmp:Bitmap;
		public var bmpData:BitmapData;
		
		var letterIndex:int = 0;
		var letter:Array;
		var partIndex:int = 0;
		var nextFrame:int = 0;
		var isHold:Boolean = false;
		
		
		public function Snowy() 
		{
			bmpData = new BitmapData(960, 540, true, 0);
			bmp = new Bitmap(bmpData, PixelSnapping.ALWAYS);
			addChild(bmp);
			bmp.width = 1920;
			bmp.height = 1080;
			
			/*maxOn = (Math.random() * 300) + 30;
			maxHold = maxOn + (Math.random() * 300) + 30;*/
			
			letters =[
				[DOT, DOT, DOT, DOT], 
				[DOT], 
				[DOT, DASH, DOT, DOT], 
				[DOT, DASH, DOT, DOT], 
				[DASH, DASH, DASH]
			];
			
			letter = letters[0];
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function frameHandler(e:Event):void 
		{
			
			if (count == nextFrame) {
				if (isHold) {
					isHold = false;
					partIndex ++;
					if (partIndex >= letter.length) {
						partIndex = 0;
						letterIndex ++;
						if (letterIndex >= letters.length) {
							letterIndex = 0;
							letter = letters[letterIndex];
							count = nextFrame = 0;
							nextFrame += SPACE;
						} else {
							letter = letters[letterIndex];
							nextFrame += BETWEEN_LETTER;
						}
					} else {
						nextFrame += BETWEEN_PART;
					}
				} else {
					isHold = true;
					nextFrame += letter[partIndex];
				}
			}
			
			if (!isHold) {
				bmpData.noise(Math.random() * 10000,0,255,7, true);
			}
			count ++;
		}
		
	}

}