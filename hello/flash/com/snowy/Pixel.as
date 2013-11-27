package com.snowy 
{
	/**
	 * ...
	 * @author steve
	 */
	public class Pixel 
	{
		
		public var xPos:int = 0;
		public var yPos:int = 0;
		public var xReal:Number = 0;
		public var yReal:Number = 0;
		public var xDir:Number = 0.01;
		public var yDir:Number = 0.01;
		public var colour:uint;
		
		public function Pixel(xPos:int) 
		{
			this.xPos = this.xReal = xPos;
			this.yPos = this.yReal = Math.random() * -10;
			if (Math.random() < 0.5) {
				colour = 0xff000000;
			} else {
				colour = 0xffffffff;
			}
		}
		
		
		
	}

}