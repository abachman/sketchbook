package {
	import org.flixel.*;

	[SWF(width="640", height="480", backgroundColor="#000000")]

	public class FirstFlixel extends FlxGame	{
		public function FirstFlixel():void {
			super(640, 480, FirstState, 2, 0xff000000, true, 0xffffffff);
		}
	}
}
