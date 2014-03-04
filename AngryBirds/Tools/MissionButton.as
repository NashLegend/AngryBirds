package Tools 
{
	import com.greensock.*;
	import Data.AngryEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Missions.Mission;
	/**
	 * ...
	 * @author IJUST
	 */
	public class MissionButton extends MovieClip
	{
		public var MissionLevel:int = 0;//它所代表的关卡级别
		public function MissionButton()
		{
			//选关按钮
			//另外它还应该有一个事件就是鼠标移入移出变大变小事件
			this.buttonMode = true;
			addEventListener(MouseEvent.CLICK, ClickMission);//被点中后要发出选关事件
			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
		}
		public function ClickMission(e:MouseEvent):void 
		{
			
			Mission.CurrentMission = this.MissionLevel;//确定关数
			
			AngryEvent.AngryBirdEvent.dispatchEvent(new Event(AngryEvent.NextMission));//触发下一关事件
			
			
		}
		public function over(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.5, { scaleX:0.7, scaleY:0.7 } );
		}
		public function out(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.5, { scaleX:0.5, scaleY:0.5 } );
		}
		
		
	}

}