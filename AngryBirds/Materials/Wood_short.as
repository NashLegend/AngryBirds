package Materials 
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Wood_short extends Wood 
	{
		
		public function Wood_short(po:Point) 
		{
			this.HP = KeyData.HP_Wood_short;
			super(po)
		}
		
	}

}