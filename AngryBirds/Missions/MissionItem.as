package Missions 
{
	/**
	 * 某一关中的特定参数  包括  位置  角度  类型
	 * 但是弹弓怎么办  只要给它一个位置就可以了  
	 * ...
	 * @author IJUST
	 */
	public class MissionItem 
	{
		public var PositionX:Number = 0;//这里的是舞台坐标  不是世界坐标
		public var PositionY:Number = 0;//这里的是舞台坐标  不是世界坐标
		public var Angle:Number = 0;//旋转角度
		public var Type:String = "";//物体类型
		
		
		
		public function MissionItem() 
		{
			
		}
		
	}

}