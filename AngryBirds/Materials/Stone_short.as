package Materials
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Stone_short extends Stone 
	{
		public function Stone_short(po:Point) 
		{
			this.HP = KeyData.HP_Stone_short;
			super(po);
		}
		
	}

}