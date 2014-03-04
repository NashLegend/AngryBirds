package Tools 
{
	import flash.display.MovieClip;
	import flash.utils.*;
	import Missions.Mission;
	
	/**
	 * ...
	 * 这里在一关过去之后并没有把这一面板去掉，它是被遮住了
	 * @author IJUST
	 */
	public class MissionPanel extends MovieClip
	{
		public function MissionPanel() 
		{
			//大的选关器
			generateAllButtons();//产生按钮
		}
		public function generateAllButtons():void
		{
			//产生按钮
			for (var i:int = 0; i < Mission.MissionArray.length; i++) 
			{
				var baseType:Class = getDefinitionByName("Tools.mb" + String(i + 1)) as Class;
				var M_Button:MissionButton = new baseType();
				M_Button.MissionLevel = i;
				
				M_Button.scaleX = M_Button.scaleY = 0.5;
				
				addChild(M_Button);
				
				M_Button.x = this.width / 7.5 * (i % 7) + this.width / 14;
				M_Button.y = this.height / 3.5 * int(i / 7) + this.height / 6;
			}
		}
	}

}