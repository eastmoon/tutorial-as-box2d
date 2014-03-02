﻿/*
	Info:
		- Reference page : http://www.emanueleferonato.com/2010/02/01/box2d-tutorial-for-the-absolute-beginners-revamped/
		- Reference page : Box2dFlashAS3 2.1a / Examples / HelloWorld.fla
		- Box2D lib : Box2dFlashAS3 2.1a, http://www.box2dflash.org/
		- Add sprite object and reference Box2D ridge body.
*/

package section.index
{
	/*import：Flash內建元件庫*/
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import flash.net.*;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import Box2D.Dynamics.b2World;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Collision.b2BroadPhase;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Collision.Shapes.b2CircleShape;
		
	public class Main extends MovieClip
	{
		/*const variable：常數變數*/
		/*member variable：物件內部操作變數*/
		private var m_environment : b2AABB;
		private var m_world : b2World;
		
		public var m_velocityIterations:int = 10;
		public var m_positionIterations:int = 10;
		public var m_timeStep:Number = 1.0/60.0;
		
		private var m_worldScale : Number = 30;
		/*display object variable：顯示物件變數，如MovieClip等*/
		
		//
		public function Main()
		{
			trace("It is Index Page");
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.Initial );
		}
		
		public function Initial( a_event : Event = null ) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.Initial);
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			// 初始化世界			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			this.m_world = new b2World( gravity, doSleep);
			// Use the given object as a broadphase. 
			// boardphase : http://http.developer.nvidia.com/GPUGems3/gpugems3_ch32.html
			//this.m_world.SetBroadPhase(new b2BroadPhase(this.m_worldAABB));
			// nable/disable warm starting. For testing. 
			this.m_world.SetWarmStarting(true);
			
			debug_draw();
			// px, py : location address，this location is center of object.
			// w, h : width、height
			// r : radius
			// d : is dynamic，this is set object type is dynamice or not. it also can setting with dynamic, kinematic, static, and default is static.
			draw_box_sprite(250,300,500,100,false);
			draw_box(250,100,100,100,true);
			draw_circle(100,100,50,false);
			draw_circle_sprite(400,100,50,true);
		}
		
		// 圓形物件
		public function draw_circle(px,py,r,d):void {
			var my_body : b2BodyDef= new b2BodyDef();
			my_body.position.Set(px/this.m_worldScale, py/this.m_worldScale);
			if (d) {
				my_body.type=b2Body.b2_dynamicBody;
			}
			var my_circle : b2CircleShape = new b2CircleShape(r/this.m_worldScale);
			var my_fixture : b2FixtureDef = new b2FixtureDef();
			my_fixture.shape = my_circle;
			var world_body : b2Body= this.m_world.CreateBody(my_body);
			world_body.CreateFixture(my_fixture);
		}
		public function draw_circle_sprite(px,py,r,d):void {
			// 產生定義物件
			var my_body : b2BodyDef= new b2BodyDef();
			// 定義物件座標
			my_body.position.Set(px/this.m_worldScale, py/this.m_worldScale);
			// 定義物件是否為動態物件
			if (d) {
				my_body.type=b2Body.b2_dynamicBody;
			}
			// 產出物件圖像
			my_body.userData = new PhysCircle();
			my_body.userData.width = r * 2; 
			my_body.userData.height = r * 2; 
			this.addChild( my_body.userData );
			// 建立物理型體
			var my_circle : b2CircleShape = new b2CircleShape(r/this.m_worldScale);
			// 建立物理定義
			var my_fixture : b2FixtureDef = new b2FixtureDef();
			my_fixture.shape = my_circle;
			// 產出物體，並設定物理參數
			var world_body : b2Body= this.m_world.CreateBody(my_body);
			world_body.CreateFixture(my_fixture);
		}
		
		// 矩型物件
		public function draw_box(px,py,w,h,d):void {
			var my_body:b2BodyDef= new b2BodyDef();
			my_body.position.Set(px/this.m_worldScale, py/this.m_worldScale);
			if (d) {
				my_body.type=b2Body.b2_dynamicBody;
			}
			var my_box : b2PolygonShape = new b2PolygonShape();
			my_box.SetAsBox(w/2/this.m_worldScale, h/2/this.m_worldScale);
			var my_fixture : b2FixtureDef = new b2FixtureDef();
			my_fixture.shape=my_box;
			var world_body : b2Body = this.m_world.CreateBody(my_body);
			world_body.CreateFixture(my_fixture);
		}
		public function draw_box_sprite(px,py,w,h,d):void {
			// 產生定義物件
			var my_body:b2BodyDef= new b2BodyDef();
			// 定義物件座標
			my_body.position.Set(px/this.m_worldScale, py/this.m_worldScale);
			// 定義物件是否為動態物件
			if (d) {
				my_body.type=b2Body.b2_dynamicBody;
			}
			// 產出物件圖像
			my_body.userData = new PhysBox();
			my_body.userData.width = w; 
			my_body.userData.height = h; 
			this.addChild( my_body.userData );
			// 建立物理型體
			var my_box : b2PolygonShape = new b2PolygonShape();
			my_box.SetAsBox(w/2/this.m_worldScale, h/2/this.m_worldScale);
			// 建立物理定義
			var my_fixture : b2FixtureDef = new b2FixtureDef();
			my_fixture.shape=my_box;
			// 產出物體，並設定物理參數
			var world_body : b2Body = this.m_world.CreateBody(my_body);
			world_body.CreateFixture(my_fixture);
		}
		
		// 偵錯系統
		public function debug_draw():void {
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			this.addChild(debug_sprite);
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(this.m_worldScale);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit);
			this.m_world.SetDebugDraw(debug_draw);
		}
		
		// 畫面更新
		public function Update(e:Event):void{
			
			this.m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			this.m_world.ClearForces();
			// 繪製Debug data
			this.m_world.DrawDebugData();
			
			// Go through body list and update sprite positions/rotations
			for(var bb:b2Body = m_world.GetBodyList(); bb; bb = bb.GetNext())
			{
				if (bb.GetUserData() is Sprite)
				{
					var sprite:Sprite = bb.GetUserData() as Sprite;
					sprite.x = bb.GetPosition().x * this.m_worldScale;
					sprite.y = bb.GetPosition().y * this.m_worldScale;
					sprite.rotation = bb.GetAngle() * (180/Math.PI);
				}
			}
			
		}
		/*public function：對外公開函數*/
		/*private function：私用函數*/
		/*constructor：建構值*/
		/*private event function：私用事件函數*/
	}
}