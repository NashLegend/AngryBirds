package  
{
	import Birds.*;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.*;
	
	/**
	 * ...
	 * 所有的世界对象的基类
	 * @author IJUST
	 */
	public class BaseObject extends MovieClip
	{
		private var _HP:int;//生命值或者耐久度
		public var HP_origin:int = 100;
		public var Friction:Number = 0.3;//摩擦力
		public var Density:Number = 1.0;//密度
		public var Restitution:Number = 0.2;
		public var Position:Point = new Point();
		public var WorldPosition:Point = new Point();
		public var AngryBody:b2Body;//刚体
		public var AngryBodyDef:b2BodyDef;//刚体属性
		public var AngryBoxDef:b2PolygonDef;//多边形定义
		public var AngryCircleDef:b2CircleDef;//圆形
		public var AngryAngle:Number = 0;
		public var removeable:Boolean;
		public var Harm:int = 0;
		public var AshScale:Number = 1.5;
		
		public function BaseObject(po:Point)
		{
			this.Position = po;
			this.x = Position.x;
			this.y = Position.y;
			this.WorldPosition = this.localToGlobal(new Point());
			addEventListener(Event.REMOVED_FROM_STAGE, getRemoved);
			addEventListener(Event.ADDED_TO_STAGE, Added_To_Stage);//只有当被添加到舞台上的时候才会被实例化刚体
			setAngryBody();//不能在被添加到舞台上的后才实例化刚体
			this.removeable = false;//开始设置为False
		}
		public function SetAngle(a:Number):void 
		{
			this.AngryBody.SetXForm(this.AngryBody.GetPosition(), a);
		}
		public function Added_To_Stage(e:Event):void
		{
			this.stop();
			SetAngle(this.rotation / (180 / Math.PI));
		}
		public function setAngryBody():void 
		{
			this.HP_origin = this.HP;
			return;
		}
		
		public function removeFromWorld():void 
		{
			this.removeable = true;
		}
		public function handleContact(HittedBody:BaseObject,ContactPoint:b2ContactPoint):void
		{
			//根据不同物体做不同反应
			return;
		}
		public function generateAshes():void 
		{
			
		}
		public function handleNoContact(ContactPoint:b2ContactPoint):void 
		{
			return;
		}
		public function update():void
		{
			var WorldPoint:Point = new Point(AngryBody.GetPosition().x * 30, AngryBody.GetPosition().y * 30);
			this.x = WorldPoint.x;
			this.y = WorldPoint.y;
			this.rotation = AngryBody.GetAngle() * 180 / Math.PI;
			
			Position.x = this.x;
			Position.y = this.y;
		}
		public function getRemoved(e:Event):void 
		{
			//删除操作之后的处理 删除侦听等等
			this.removeEventListener(Event.ADDED_TO_STAGE, Added_To_Stage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, getRemoved);
			return;
		}
		public function setShapeByHP():void
		{
			//根据HP值来改变外观
			return;
		}
		public function set HP(value:int):void 
		{
			_HP = value;
			setShapeByHP();
		}
		
		public function get HP():int 
		{
			return _HP;
		}
	}

}