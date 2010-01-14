package {
	import org.flixel.*;
	public class FirstState extends FlxState {
		[Embed(source="ball.png")] private var imgBall:Class;

		private var text:FlxText;
		private var ball:FlxSprite;

		public function FirstState():void {
			text = new FlxText(20, 20, 100, 10, "hello",0xffffffff);
      ball = new FlxSprite(imgBall, 100, 240);
			this.add(text);
      this.add(ball);
		}

		override public function update():void {
			super.update();
		}
	}
}
