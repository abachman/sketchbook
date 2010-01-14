package {

  import org.flixel.*;

  public class Ball extends FlxSprite {
		[Embed(source="ball.png")] private var imgBall:Class;

		public function Ball(X:int,Y:int)
		{
			super(imgBall,X,Y,true,true);
    }

    override public function update():void {
      super.update();
    }
  }
}

