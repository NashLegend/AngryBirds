package Tools 
{
	import Data.AngryEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.*;
	/**
	 * ...
	 * @author IJUST
	 */
	public class ReplayButton extends MovieClip 
	{
		
		public function ReplayButton() 
		{
			addEventListener(MouseEvent.CLICK, M_Failed);
			addEventListener(MouseEvent.MOUSE_OVER, over);
			addEventListener(MouseEvent.MOUSE_OUT, out);
			this.buttonMode = true;
			
		}
		public function M_Failed(e:MouseEvent):void 
		{
			AngryEvent.AngryBirdEvent.dispatchEvent(new Event(AngryEvent.MissionFailed));
		}
		public function over(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.5, { scaleX:1.5, scaleY:1.5 } );
		}
		public function out(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.5, { scaleX:1, scaleY:1 } );
		}
		
	}

}