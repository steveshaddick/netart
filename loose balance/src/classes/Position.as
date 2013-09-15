package classes
{
	import flash.display.MovieClip;
	
	/**
	* ...
	* @author Steve
	*/
	public class Position extends MovieClip
	{
		
		public var movEmptyBG:MovieClip;
		public var movLoadedBG:MovieClip;
		public var movPositionBG:MovieClip;
		
		public function Position():void 
		{
			movLoadedBG.scaleX = 1;
			movPositionBG.scaleX = 1;
		}
		
		public function advanceLoaded(_perc:Number):void 
		{
			if (_perc > 1)
			{
				_perc = 1;
			}
			if (_perc < 0)
			{
				_perc = 0;
			}
			movLoadedBG.scaleX = _perc;
		}
		
		public function advancePosition(_perc:Number):void 
		{
			if (_perc > 1)
			{
				_perc = 1;
			}
			if (_perc < 0)
			{
				_perc = 0;
			}
			
			movPositionBG.scaleX = _perc;
		}
	}
	
}