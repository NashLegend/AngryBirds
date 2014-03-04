package Data 
{
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author IJUST
	 */
	public class KeyData 
	{
		//其他杂项设置
		public static const BirdSceneWidth:int = 1800;
		public static const BirdSceneHeight:int = 675;
		public static const StageWidth:int = 1200;
		public static const StageHeight:int = 675;
		public static const SlingLength:Number = 100;
		public static const B2Vec_To_Impulse:Number = 10;//距离与矢量的关系
		public static const StrapHeight:Number = 10;//弹弓带子的宽度
		public static const MinImpulse:Number = 10;//把鸟发射出去的最小的力
		public static const AshMaxSpeed:Number = 1.5;
		public static const AshMaxRotate:Number = 4;
		public static const AshRemoveTime:int = 2000;
		public static const AshScaleRation = 0.98;
		//鼠标状态
		
		//所有小鸟的材质设置参数
		public static const Bird_Harm_Feather:Number = 15;//小鸟有受到至少多少伤害的时候掉毛
		public static const Bird_Harm_To_Feathers:Number = 10;//伤害与掉毛的比率
		public static const FeatherMax:int = 14;
		public static const Bird_Feather_Radious:Number = 50;
		public static const Bird_Die_Speed:Number = 0.2;//小鸟在碰撞后当速度小于多少时可以去死了
		public static const Bird_Die_Distance:int = 2100;//小鸟多远就可以死了
		public static const Pig_Die_Slow:int = 1850;//猪在速度足够小的时候，大于多少的位置就可以死了
		
		public static const Bird_State_On_Ground:String = "birdstateonground";//在地面时等待上发射架时
		public static const Bird_State_On_Slingshot:String = "birdstateonslingshot";//在弹弓上等待发射时
		public static const Bird_State_On_Flying:String = "birdstateonwokenup";//发射出去后撞上去之前
		public static const Bird_State_On_HitObjects:String = "birdstateonhitobjects";//发射出去且撞上物体之后死亡之前的状态：小鸟的HP值仅仅提供碰撞效果的参考，因为其死后仍然有杀伤力
		public static const Bird_Current_Dead:String = "birdcurrentdead";//当前小鸟已死
		public static const SpeedUp:Number = 2.0;//小鸟加速倍数
		public static const TurnAngle:Number = 10;
		
		public static const Density_BlueBird:Number = 2.0;
		public static const Friction_BlueBird:Number = 0.3;
		public static const Restitution_BlueBird:Number = 0.3;
		
		public static const Density_RedBird:Number = 2;
		public static const Friction_RedBird:Number = 0.3;
		public static const Restitution_RedBird:Number = 0.3;
		
		public static const Density_YellowBird:Number = 2;
		public static const Friction_YellowBird:Number = 0.2;
		public static const Restitution_YellowBird:Number = 0.3;
		
		//所有猪头的材质设置参数
		public static const Harm_Coefficient_Bird_To_Pig:Number = 5;
		
		public static const Density_LittlePig:Number = 3;
		public static const Friction_LittlePig:Number = 0.3;
		public static const Restitution_LittlePig:Number = 0.4;
		public static const Radious_LittlePig:Number = 24;
		public static const HP_LittlePig:int = 150;
		
		public static const Density_CommonPig:Number =3;
		public static const Friction_CommonPig:Number = 0.3;
		public static const Restitution_CommonPig:Number = 0.5;
		public static const Radious_CommonPig:Number = 40;
		public static const HP_CommonPig:int = 300;
		
		//所有材料的材质设置参数
		public static const Harm_Coefficient_Blue_To_Glass:Number = 3;
		public static const Harm_Coefficient_Yellow_To_Wood:Number = 3;
		
		public static const Density_Ground:Number = 0;
		public static const Friction_Ground:Number = 0.2;
		public static const Restitution_Ground:Number = 0.3;
		
		public static const Density_1s:Number = 0;
		public static const Friction_1s:Number = 0.75;
		public static const Restitution_1s:Number = 0.3;
		
		public static const HP_Glass_long:int = 120;
		public static const HP_Glass_middle:int = 150;
		public static const HP_Glass_short:int = 180;
		public static const Density_Glass:Number = 2.0;
		public static const Friction_Glass:Number = 0.5;
		public static const Restitution_Glass:Number = 0.3;
		
		public static const HP_Stone_long:int = 180;
		public static const HP_Stone_middle:int = 225;
		public static const HP_Stone_short:int = 270;
		public static const Density_Stone:Number = 4.5;
		public static const Friction_Stone:Number = 0.5;
		public static const Restitution_Stone:Number = 0.3;
		
		public static const HP_Wood_long:int = 160;
		public static const HP_Wood_middle:int = 200;
		public static const HP_Wood_short:int = 240;
		public static const Density_Wood:Number = 0.8;
		public static const Friction_Wood:Number = 0.5;
		public static const Restitution_Wood:Number = 0.3;
		
	}

}