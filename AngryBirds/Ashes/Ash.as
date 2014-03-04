package Ashes 
{
	import Data.KeyData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Ash extends MovieClip
	{
		protected var Direction:int;
		protected var RotateSpeed:Number;
		protected var SpeedX:Number;
		protected var SpeedY:Number;
		protected var Speed:Number;
		protected var Ter:Number;
		public var scal:Number = 0.95;
		public function Ash(sca:Number) 
		{
			this.scaleX = this.scaleY = sca - Math.random() / 3;//确定大小
			this.rotation = 360 * Math.random();//角度
			this.Direction = 360 * Math.random();
			scal = KeyData.AshScaleRation;
			
			Ter = this.scaleX * (Math.random() / 5 + 0.2);
			this.Speed = KeyData.AshMaxSpeed * (0.3 + Math.random() * 2 / 3);
			this.SpeedX = this.Speed * Math.cos(Direction * Math.PI / 180);
			this.SpeedY = this.Speed * Math.sin(Direction * Math.PI / 180);
			this.RotateSpeed = KeyData.AshMaxRotate * Math.random() * ( -1 + Math.random() * 2);//转速
			
			addEventListener(Event.ENTER_FRAME, moveRandom);
		}
		public function moveRandom(e:Event):void 
		{
			this.rotation += this.RotateSpeed;
			this.x += this.SpeedX;
			this.y += this.SpeedY;
			this.scaleX = this.scaleY = this.scaleX * scal;
			
			if (this.scaleX<this.Ter)
			{
				remove();
			}
		}
		public function remove():void 
		{
			this.removeEventListener(Event.ENTER_FRAME, moveRandom);
			if (this.parent) 
			{
				this.parent.removeChild(this);
			}
		}
	}

}