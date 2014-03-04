package Materials 
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Glass_short extends Glass 
	{
		
		public function Glass_short(po:Point) 
		{
			this.HP = KeyData.HP_Glass_short;
			super(po);
		}
		
	}

}