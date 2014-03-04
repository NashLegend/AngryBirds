package Tools 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author IJUST
	 */
	public class MissionPassPanel extends MovieClip 
	{
		public function MissionPassPanel() 
		{
			//过关显示面板
			var next:NextButton = new NextButton();
			var replay:ReplayButton = new ReplayButton();
			addChild(replay);
			addChild(next);
			replay.x = 100;
			replay.y = 80;
			next.x = 250;
			next.y = 80;
		}
	}

}