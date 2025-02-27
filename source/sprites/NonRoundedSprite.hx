package sprites;

import flixel.FlxSprite;
import flixel.math.FlxRect;

class NonRoundedSprite extends FlxSprite
{
	@:noCompletion override function set_clipRect(rect:FlxRect):FlxRect
	{
		clipRect = rect;
		if (frames != null)
			frame = frames.frames[animation.frameIndex];
		return rect;
	}
}
