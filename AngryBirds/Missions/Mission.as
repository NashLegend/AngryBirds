package Missions
{
	import Data.AngryEvent;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Mission 
	{
		public static var MissionGroup:int = 0;//第几个大关卡
		public static var MissionArray:Array = [];//关卡数组
		/*当前关卡数组CurrentMissionArray为MissionArray的一个单项  
		 * 而CurrentMissionArray里的单项是由MissionItem类来作为VO的
		 * 从getMission()静态方法可以得到CurrentMissionArray的值
		 * */
		public static var CurrentMissionArray:Array = [];
		public static var CurrentMission:int = 0;//当前关卡级别 未玩的时候为0
		
		public static var XMLloader:URLLoader = new URLLoader();
		public static var XMLrequest:URLRequest = new URLRequest();
		public static var XMLdata:XML = new XML();
		public static var CurrentXML:XML = new XML();
		
		public function Mission() 
		{
			
		}
		
		public static function getMissionData():void 
		{
			//从XML文件里提取关卡数据  当然也有可能上二进制文件
			//并从提取出来的关卡数据里面解析出关卡数组
			XMLloader.dataFormat = URLLoaderDataFormat.TEXT;
			XMLrequest.url = "Missions/Levels.xml";
			XMLloader.addEventListener(Event.COMPLETE, loadComplete);
			XMLloader.addEventListener(IOErrorEvent.IO_ERROR, IOErrors);
			XMLloader.load(XMLrequest);
		}
		public static function IOErrors(e:IOErrorEvent):void 
		{
			trace("IOError");
		}
		public static function loadComplete(e:Event):void 
		{
			XMLdata = XML(XMLloader.data);
			var  num:int = XMLdata.children().length();
			for (var i:int = 0; i < num; i++) 
			{
				var item:XML = XMLdata.level[i];
				MissionArray.push(item);
			}
			AngryEvent.AngryBirdEvent.dispatchEvent(new Event(AngryEvent.AllDataLoaded));
		}
		public static function getMission(Mis:int):void
		{
			Mission.CurrentMissionArray = [];
			Mission.CurrentXML = MissionArray[Mis] as XML;
			for each (var item:XML in Mission.CurrentXML.item) 
			{
				var WorldItem:MissionItem = new MissionItem();
				WorldItem.Angle = item.rotation;
				WorldItem.PositionX = item.positionX;
				WorldItem.PositionY = item.positionY;
				WorldItem.Type = item.type;
				Mission.CurrentMissionArray.push(WorldItem);
			}
		}
		
		
	}

}