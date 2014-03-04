package Tools 
{
	import Data.KeyData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author IJUST
	 */
	public class Strap extends Sprite 
	{
		private var sp:Sprite = new Sprite();
		public function Strap() 
		{
			addChild(sp);
			sp.graphics.beginFill(0x800040, 1);
			sp.graphics.drawRect(0, KeyData.StrapHeight/2, 1, KeyData.StrapHeight);
			sp.graphics.endFill();
		}
		public function setLength(l:Number ):void 
		{
			sp.width = l;
		}
		
	}

}