package Materials 
{
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Glass_middle extends Glass 
	{
		
		public function Glass_middle(po:Point) 
		{
			this.HP = KeyData.HP_Glass_middle;
			super(po);
		}
		
	}

}