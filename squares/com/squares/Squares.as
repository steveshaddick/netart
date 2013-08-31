package com.squares
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author steve shaddick
	 */
	public class Squares extends Sprite  
	{
		
		private static const AMOUNT:int = 500001;
		private var squares:Vector.<NonSquare> = new Vector.<NonSquare>();
		
		private var colour:uint = 0;
		private var needNew:Boolean = true;
		
		private var bmp:Bitmap;
		private var bmpData:BitmapData;
		
		private var squareHolder:Sprite;
		
		public function Squares()
		{
			addEventListener(Event.ADDED_TO_STAGE, stageHandler);
		}
		
		private function stageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageHandler);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			bmpData = new BitmapData(stage.stageWidth, stage.stageHeight);
			bmp = new Bitmap(bmpData);
			addChild(bmp);
			
			squareHolder = new Sprite();
			addChild(squareHolder);
			
			var tmr:Timer = new Timer(1000, 0);
			tmr.addEventListener(TimerEvent.TIMER, tmrHandler);
			tmr.start();
			
		}
		
		private function resizeHandler(e:Event):void 
		{
			bmp.x = (stage.stageWidth / 2) - (bmp.width / 2);
			bmp.y = (stage.stageHeight / 2) - (bmp.height / 2);
			
			var oldData:BitmapData = bmpData;
			bmpData = new BitmapData(stage.stageWidth, stage.stageHeight);
			bmpData.draw(oldData, new Matrix(1, 0, 0, 1, (bmpData.width - oldData.width) / 2, (bmpData.height - oldData.height) / 2));
			bmp.bitmapData = bmpData;
		}
		
		private function tmrHandler(e:TimerEvent):void 
		{
			if (needNew) {
				var newSquare:NonSquare = new NonSquare(colour);
				newSquare.addEventListener(NonSquare.DONE, doneHandler);
				
				squareHolder.addChild(newSquare);
				colour += AMOUNT;
				
				if (colour > 0xFFFFFF) {
					colour -= 0xFFFFFF;
				}
				
				needNew = false;
			}
		}
		
		private function doneHandler(e:Event):void 
		{
			var nonSquare:NonSquare = e.target as NonSquare;
			nonSquare.removeEventListener(NonSquare.DONE, doneHandler);
			
			bmpData.draw(squareHolder);
			squareHolder.removeChild(nonSquare);
			
			needNew = true;
			
		}
		
		
	}
	
}