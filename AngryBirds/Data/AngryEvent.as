package Data 
{
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author IJUST
	 */
	public class AngryEvent
	{
		//各种要触发的事件
		public static const AngryBirdEvent:EventDispatcher = new EventDispatcher();
		
		//下面才是事件
		public static const AllObjectsStop:String = "allobjectsstop";
		public static const AllPigsDead:String = "allpigsdead";
		
		
		
		//下面是重大事件  如换关  换界面
		public static const AllDataLoaded:String = "alldataloaded";
		public static const MissionPass:String = "missionpass";
		public static const NextMission:String = "nextmission";
		public static const MissionFailed:String = "missionfailed";
		public static const AllMissionsOver:String = "AllMissionsOver";
		
		
		public function AngryEvent() 
		{
			
		}
		
		
	}

}