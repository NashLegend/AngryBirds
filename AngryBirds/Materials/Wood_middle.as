package Materials 
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Wood_middle extends Wood 
	{
		
		public function Wood_middle(po:Point) 
		{
			this.HP = KeyData.HP_Wood_middle;
			super(po);
		}
		
	}

}