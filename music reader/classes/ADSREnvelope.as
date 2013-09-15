package classes 
{
	import com.boostworthy.collections.iterators.NullIterator;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.media.SoundTransform;
	import flash.display.Stage;
	import flash.media.Sound;
	
	/**
	* ...
	* @author Steve
	*/
	public class ADSREnvelope
	{
		public var attack:Number;
		public var decay:Number;
		public var sustain:Number;
		public var release:Number;
		
		public var attackVol:Number = 1;
		public var decayVol:Number = 1;
		
		public var stage:Stage;
		
		public var sndTransform:SoundTransform = new SoundTransform();
		public var sndChannel:SoundChannel;
		public var snd:Sound;
		
		private var startTime:uint = 0;
		private var mode:String = "attack";
		private var maxVolume:Number = 1;
		
		private var incAttack:Number;
		private var incDecay:Number;
		private var incRelease:Number;
	
		
		public function ADSREnvelope(_attack:Number = 0, _decay:Number = 0, _sustain:Number = 1000, _release:Number = 1000 ):void 
		{
			attack = _attack;
			decay = _decay;
			sustain = _sustain;
			release = _release;
		}
		
		public function startEnvelope(_snd:Sound, _vol:Number):void
		{
			
			startTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, frameHandler);
			
			snd = _snd;
			
			
			if (attack > 0){
				incAttack = attackVol / ((1/stage.frameRate) * attack);
				mode = "attack";
				attackVol = _vol;
				sndTransform.volume = 0;
				if (decay > 0){
					incDecay = (attackVol-decayVol) / ((1/stage.frameRate) * decay);
				} else {
					decayVol = _vol;
				}
			} else {
				sndTransform.volume = _vol;
				mode = "sustain";
			}
			
			sndChannel = snd.play(0, 0, sndTransform);
			
		}
		
		private function frameHandler(_event:Event):void 
		{
			var currTime:uint = getTimer();
			var elapsed:uint = currTime - startTime;
			
			if (sndChannel == null) {
				stage.removeEventListener(Event.ENTER_FRAME, frameHandler);
			}
			
			switch (mode) {
				case "attack":
				if (elapsed < attack) {
					//trace(elapsed);
					sndTransform.volume +=incAttack;
				} else {
					sndTransform.volume = attackVol;
					mode = "decay";
					startTime = currTime;
				}
				break;
				
				case "decay":
				if (elapsed < decay) {
					sndTransform.volume -= incDecay;
				} else {
					sndTransform.volume = decayVol;
					mode = "sustain";
					startTime = currTime;
				}
				break;
				
				case "sustain":
				if (elapsed >= sustain) {
					mode = "release";
					startTime = currTime;
					if (release > 0) {
						incRelease = sndTransform.volume / ((1/stage.frameRate) * release);
						
					}
				}
				break;
				
				case "release":
				if (elapsed < release) {
					sndTransform.volume -= incRelease;
					//trace(incRelease);
					//trace(sndTransform.volume);
				} else {
					sndTransform.volume = 0;
					sndChannel.stop();
					stage.removeEventListener(Event.ENTER_FRAME, frameHandler);
					//sndChannel = null;
				}
				
				
			}
			sndChannel.soundTransform = sndTransform;
		}
	}
	
}