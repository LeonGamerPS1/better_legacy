package sprites;

import lime.utils.Assets;
import flixel.math.FlxRect;
import flixel.FlxSprite;

class Sustain extends NonRoundedSprite
{
	public var parent:Note;
	public var tail:NonRoundedSprite;

	public function new(parent:Note)
	{
		super();
		this.parent = parent;
		reloadSustain(parent);
	}

	public function reloadSustain(parent:Note)
	{
		if (parent.isPixel)
			pixel();
		else
			normal();
	}

	function normal()
	{
		frames = parent.frames;
		animation.copyFrom(parent.animation);

		animation.play(parent.getSustainAnimation());
		updateHitbox();
		@:privateAccess
		setGraphicSize(width * (!parent.isPixel ? 0.7 : 6), parent.height / 2 * 0.75);
		updateHitbox();

		tail = new NonRoundedSprite(x, y);
		tail.frames = frames;
		tail.animation.copyFrom(animation);
		tail.animation.play(parent.getTailAnimation());
		tail.updateHitbox();

		tail.setGraphicSize(width, height);
		tail.updateHitbox();
		tail.antialiasing = parent.antialiasing;
	}

	function pixel()
	{
		var tex = 'arrow';
		var data = parent.noteData;

		loadGraphic('assets/images/${tex}Ends.png', 'week6');
		loadGraphic('assets/images/${tex}Ends.png', true, 7, 6);

		animation.add('hold', [data], 12, false);
		animation.add('end', [data + 4], 12, false);
		animation.play("hold");
		updateHitbox();

		setGraphicSize(width * 6);
		updateHitbox();

		tail = new NonRoundedSprite(x, y);
		tail.frames = frames;
		tail.animation.copyFrom(animation);
		tail.animation.play("end");
		tail.updateHitbox();

		tail.setGraphicSize(width, height);
		tail.updateHitbox();
		tail.antialiasing = parent.antialiasing;
	}

	override function draw()
	{
		setGraphicSize(width, Math.abs((parent.sustainLength * 0.45 * parent.speed) - tail.height));
		updateHitbox();
		alpha = parent.alpha * 0.6;

		setPosition(parent.x + (parent.width - width) / 2, parent.y + parent.height / 2);
		tail.cameras = cameras;

		tail.alpha = alpha;
		tail.x = x;
		tail.y = y + (!parent.downScroll ? height : (-height - tail.height));

		if (tail.flipY != flipY)
			tail.flipY = flipY;
		if (parent.downScroll)
		{
			flipY = true;
			y += -height;
		}
		else
			flipY = false;

		if (parent.wasGoodHit)
			clip();

		super.draw();
		tail.draw();
	}

	inline public function clip()
	{
		var center:Float = parent.clipPoint.y;

		var swagRect:FlxRect = clipRect;
		if (swagRect == null)
			swagRect = new FlxRect(0, 0, frameWidth, frameHeight);

		if (parent.downScroll)
		{
			if (y - offset.y * scale.y + height >= center)
			{
				swagRect.width = frameWidth;
				swagRect.height = (center - y) / scale.y;
				swagRect.y = frameHeight - swagRect.height;
			}
		}
		else if (y + offset.y * scale.y <= center && !parent.downScroll)
		{
			swagRect.y = (center - y) / scale.y;
			swagRect.width = width / scale.x;
			swagRect.height = (height / scale.y) - swagRect.y;
		}

		clipRect = swagRect;
		clipTail();
	}

	inline public function clipTail()
	{
		var center:Float = parent.clipPoint.y;
		var tailEnd = tail;
		var isDownscroll = parent.downScroll;
		if (clipRect.height < 0)
		{
			var swagRect:FlxRect = tailEnd.clipRect;
			if (swagRect == null)
				swagRect = FlxRect.get(0, 0, isDownscroll ? tailEnd.frameWidth : tailEnd.width / tailEnd.scale.x, tailEnd.frameHeight);

			if (parent.downScroll)
			{
				if (tailEnd.y + tailEnd.height >= center)
				{
					swagRect.height = (center - tailEnd.y) / tailEnd.scale.y;
					swagRect.y = tailEnd.frameHeight - swagRect.height;
				}
			}
			else
			{
				if (tailEnd.y <= center)
				{
					swagRect.y = (center - tailEnd.y) / tailEnd.scale.y;
					swagRect.height = (tailEnd.height / tailEnd.scale.y) - swagRect.y;
				}
			}
			tailEnd.clipRect = swagRect;
		}
	}

	override function destroy()
	{
		tail.destroy();
		tail = null;
		super.destroy();
	}
}
