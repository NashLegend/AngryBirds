package Materials 
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Glass_long extends Glass 
	{
		
		public function Glass_long(po:Point) 
		{
			this.HP = KeyData.HP_Glass_long;
			super(po);
		}
		override public function setAngryBody():void 
		{
			super.setAngryBody();
			
		}
		
	}

}