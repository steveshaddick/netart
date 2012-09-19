package com.colourbars 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import com.utils.ColourUtils;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Steve
	 */
	public class ChangingBar extends Sprite 
	{
		
		private var originalWidth:Number;
		private var originalX:Number;
		private var originalTint:uint;
		
		private var lastTint:uint;
		
		private var maxChange:Number;
		
		private var widthTimeout:uint;
		private var tintTimeout:uint;
		
		private var isTint:Boolean = true;
		private var isRevert:Boolean = false;
		
		private var originalHSV:Object = {
			hue:0,
			sat:0,
			val:0
		}
		private var newHSV:Object = {
			hue:0,
			sat:0,
			val:0
		}
		
		public function ChangingBar() 
		{
			originalWidth = this.width;
			originalX = this.x;
			originalTint = lastTint = this.transform.colorTransform.color;
			
			var rgb:Array = ColourUtils.HexToRGB(originalTint);
			var hsvColours:Array = ColourUtils.RGBtoHSV(rgb[0], rgb[1], rgb[2]);
			newHSV.hue = originalHSV.hue = hsvColours[0];
			newHSV.sat = originalHSV.sat = hsvColours[1];
			newHSV.val = originalHSV.val = hsvColours[2];
			
			isTint = (originalHSV.sat == 100);
			//trace(this.name, originalTint, originalHSV.hue, originalHSV.sat, originalHSV.val);
			maxChange = originalWidth * 0.1;
		}
		
		public function changeWidth():void 
		{
			if (Math.random() < 0.5) {
				widthTimeout = setTimeout(changeWidth, (Math.random() * 10000) + 5000);
				return;
			}
			clearTimeout(widthTimeout);
			
			if (isRevert) {
				isRevert = false;
				TweenLite.killTweensOf(this);
			}
			
			var newWidth:Number;
			
			if (width > originalWidth) {
				newWidth = originalWidth - (Math.random() * maxChange);
			} else if (width < originalWidth) {
				newWidth = originalWidth + (Math.random() * maxChange);
			} else {
				newWidth = (Math.random() < 0.5) ? originalWidth - (Math.random() * maxChange) : originalWidth + (Math.random() * maxChange);
			}
			
			var newX:Number = originalX + ((originalWidth - newWidth) / 2);
			
			TweenLite.to(this, (Math.random() * 10) + 10, { overwrite:false, width: newWidth, x:newX, ease:Linear.easeNone, onComplete: changeWidth } );
		}
		
		public function changeTint():void 
		{
			if (Math.random() < 0.5) {
				tintTimeout = setTimeout(changeTint, (Math.random() * 10000) + 5000);
				return;
			}
			clearTimeout(tintTimeout);
			
			if (isRevert) {
				isRevert = false;
				TweenLite.killTweensOf(this);
			}
			
			if (isTint) {
				
				if (Math.random() > 0.5) {
					newHSV.hue = originalHSV.hue + (Math.random() * 10) + 10;
				} else {
					newHSV.hue = originalHSV.hue - (Math.random() * 10) + 10;
				}
				
			} else {
				
				if (Math.random() > 0.5) {
					newHSV.val = originalHSV.val + (Math.random() * 5) + 5;
				} else {
					newHSV.val = originalHSV.val - (Math.random() * 5) + 5;
				}
			}
			
			var rgb:Array = ColourUtils.HSVtoRGB(newHSV.hue, newHSV.sat, newHSV.val);
			trace("change tint", this.name, newHSV.hue, newHSV.sat, newHSV.val);
			TweenLite.to(this, (Math.random() * 10) + 20, { overwrite:false, tint: ColourUtils.RGBToHex(rgb[0], rgb[1], rgb[2]), ease:Linear.easeNone, onComplete: changeTint } );
		}
		
		public function revert():void 
		{
			clearTimeout(tintTimeout);
			clearTimeout(widthTimeout);
			trace("reverting", this.name);
			isRevert = true;
			TweenLite.to(this, 10, { width: originalWidth, x:originalX, tint: originalTint, ease:Sine.easeInOut } );
		}
		
	}

}