package Score 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author IJUST
	 */
	public class ScoreCounter extends MovieClip 
	{
		public static var Scores:int = 0;
		public var ScoreBoard:TextField;
		public var txtFormat:TextFormat;
		public function ScoreCounter() 
		{
			ScoreBoard = new TextField();
			ScoreBoard.width = 200;
			txtFormat = new TextFormat();
			txtFormat.color = 0xFF0000;
			txtFormat.size = 48;
			txtFormat.font = "Arial";
			txtFormat.bold = true;
			ScoreBoard.defaultTextFormat = txtFormat;
			ScoreBoard.selectable = false;
			addChild(ScoreBoard);
			//右上角的计分板
		}
		
	}

}