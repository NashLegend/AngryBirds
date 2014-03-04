package Tools 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MissionFailPanel extends MovieClip 
	{
		public function MissionFailPanel()
		{
			var replay:ReplayButton = new ReplayButton();
			addChild(replay);
			replay.x = this.width/2-10;
			replay.y = 80;
		}
		
	}

}