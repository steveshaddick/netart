package classes
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	
	/**
	* ...
	* @author Steve
	*/
	public class NoteInfo extends MovieClip 
	{
		
		public var txtVolume:TextField;
		public var txtRegister:TextField;
		public var txtNote:TextField;
		
		
		public function NoteInfo():void 
		{
			this.alpha = 0;
		}
		
		public function setText(_loc:String, _val:String):void 
		{
			_val = _val.replace("sharp", "#");
			//trace(_val);
			switch (_loc)
			{
				case "volume":
				txtVolume.text = _val;
				break;
				
				case "register":
				//trace("reg: " + _val);
				txtRegister.text = _val;
				break;
				
				case "note":
				txtNote.text = _val;
				break;
			}
		}
		
		public function illuminate():void 
		{
			this.alpha = 1;
			
			Tweener.removeTweens(this);
			Tweener.addTween(this, { alpha:0, time: 5 } );
		}
	}
	
}