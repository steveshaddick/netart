package classes
{
	import flash.display.MovieClip;
	
	/**
	* ...
	* @author Steve
	*/
	public class VolumeBars extends MovieClip
	{
		public var movBar1:MovieClip;
		public var movBar2:MovieClip;
		public var movBar3:MovieClip;
		public var movBar4:MovieClip;
		
		public function VolumeBars():void 
		{
			movBar1.alpha = 0;
			movBar2.alpha = 0;
			movBar3.alpha = 0;
			movBar4.alpha = 0;
		}
		
		public function setVolume(_perc:Number):void 
		{
			var tmp:Number = (_perc * 100) / 25;
			
			//trace(tmp);
			if (tmp >= 1) {
				movBar1.alpha = 1;
				if (tmp >= 2) {
					movBar2.alpha = 1;
					if (tmp >= 3) {
						movBar3.alpha = 1;
						if (tmp == 4) {
							movBar4.alpha = 1;
						} else {
							movBar4.alpha = tmp - 3;
						}
					} else {
						movBar4.alpha = 0;
						movBar3.alpha = tmp - 2;
					}
				} else {
					movBar4.alpha = 0;
					movBar3.alpha = 0;
					movBar2.alpha = tmp - 1;
				}
			} else {
				movBar4.alpha = 0;
				movBar3.alpha = 0;
				movBar2.alpha = 0;
				movBar1.alpha = tmp;
			}
		}
		
	}
	
}