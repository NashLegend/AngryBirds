package Materials 
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Stone_middle extends Stone 
	{
		public function Stone_middle(po:Point) 
		{
			this.HP = KeyData.HP_Stone_middle;
			super(po)
		}
		
	}

}