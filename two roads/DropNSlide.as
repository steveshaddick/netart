﻿import mx.transitions.Tween;import mx.transitions.easing.*;class DropNSlide{		private var mov:MovieClip;		private var side:String;		private var startX:Number;	private var endX:Number;			function slideOut(){				var twn:Tween = new Tween(this.mov, "_x", Strong.easeOut, this.mov._x, this.startX, 1.75, true);		}			function slideIn(_endX:Number){				this.endX = _endX;		var twn:Tween = new Tween(this.mov, "_x", Strong.easeOut, this.mov._x, this.endX, 1.75, true);		}			function DropNSlide(_mom:MovieClip, _movName:String, _side:String, _depth:Number){trace("creating " + _movName);		this.mov = _mom.attachMovie(_movName, _movName+"_"+_depth, _depth);				this.side = _side;				switch(this.side){			case "left":			this.startX = -this.mov._width;						break;						case "right":			this.startX = Stage.width;			break;		}				this.mov._x = this.startX;						}	}