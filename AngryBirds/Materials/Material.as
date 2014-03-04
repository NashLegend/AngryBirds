package Materials 
{
	import flash.geom.Point;
	import Data.KeyData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Material extends BaseObject
	{
		public var HasGe:Boolean = false;
		public function Material(po:Point) 
		{
			this.mouseEnabled = false;
			super(po);
		}
		
		override public function update():void
		{
			super.update();
			if (this.x<0||this.x>KeyData.Bird_Die_Distance)
			{
				removeFromWorld();
			}
		}
		
	}

}