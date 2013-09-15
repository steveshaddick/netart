package classes 
{
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.media.SoundTransform;
	import flash.display.Stage;
	
	/**
	* ...
	* @author Steve
	*/
	public class ADSREnvelope
	{
		public var attack:Number = 0;
		public var decay:Number = 0;
		public var sustain:Number = 3000;
		public var release:Number = 3000;
		
		public var attackVol:Number = 1;
		public var decayVol:Number = 1;
		
		private var startTime:uint = 0;
		private var mode:String = "attack";
		private var maxVolume:Number = 1;
		
		private var incAttack:Number;
		private var incDecay:Number;
		private var incRelease:Number;
		
		public function ADSREnvelope():void 
		{
			this.soundTransform = new SoundTransform();
		}
		
		public function startEnvelope():void
		{
			
			startTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, frameHandler);
			
			if (attack > 0){
				incAttack = attackVol / ((1/stage.frameRate) * attack);
				mode = "attack";
				if (decay > 0){
					incDecay = (attackVol-decayVol) / ((1/stage.frameRate) * decay);
				}
			} else {
				mode = "sustain";
			}
			
		}
		
		private function frameHandler(_event:Event):void 
		{
			var currTime:uint = getTimer();
			var elapsed:uint = currTime - startTime;
			
			switch (mode) {
				case "attack":
				if (elapsed < attack) {
					soundTransform.volume +=incAttack;
				} else {
					soundTransform.volume = soundTransform.volume = attackVol;
					mode = "decay";
					startTime = currTime;
					
				}
				break;
				
				case "decay":
				if (elapsed < decay) {
					soundTransform.volume -= incDecay;
				} else {
					soundTransform.volume = soundTransform.volume = decayVol;
					startTime = currTime;
				}
				break;
				
				case "sustain":
				if (elapsed >= sustain) {
					mode = "release";
					startTime = currTime;
					if (release > 0) {
						incRelease = soundTransform.volume / ((1/stage.frameRate) * release);
					}
				}
				break;
				
				case "release":
				if (elapsed < release) {
					soundTransform.volume -= incRelease;
				} else {
					soundTransform.volume = 0;
					this.stop();
				}
				
				
			}
		}
	}
	
}