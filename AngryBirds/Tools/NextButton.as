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
	public class NextButton extends MovieClip 
	{
		
		public function NextButton() 
		{
			addEventListener(MouseEvent.CLICK, Next);
			addEventListener(MouseEvent.MOUSE_OVER, over);
			addEventListener(MouseEvent.MOUSE_OUT, out);
			this.buttonMode = true;
		}
		public function Next(e:MouseEvent):void 
		{
			AngryEvent.AngryBirdEvent.dispatchEvent(new Event(AngryEvent.MissionPass));
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