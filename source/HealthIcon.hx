package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	var char:String = '';
	var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		changeIcon(char);
		antialiasing = true;
		scrollFactor.set();
	}

	public var isOldIcon:Bool = false;

	public function swapOldIcon():Void
	{
		isOldIcon = !isOldIcon;

		if (isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon(PlayState.SONG.player1);
	}

	private var iconOffsets:Array<Float> = [0, 0];

	public function changeIcon(newChar:String):Void
	{
		if (newChar != char)
		{
			if (animation.getByName(newChar) == null)
			{
				var path = Paths.image('icons/icon-$newChar');
				if (!openfl.Assets.exists(path))
					path = Paths.image('icons/icon-face');

				loadGraphic(path); // loading the full image for getting the height and width of the image first
				var iSize:Float = Math.round(width / height);
				loadGraphic(path, true, Std.int(width / 2), Std.int(height)); // now adjusting the frame height and width to fit
				iconOffsets[0] = (width - 150) / iSize;
				iconOffsets[1] = (height - 150) / iSize;
				updateHitbox();
				animation.add(newChar, [0, 1], 0, false, isPlayer);
			}
			animation.play(newChar);
			char = newChar;
		}
	}

	public var autoAdjustOffset:Bool = true;

	override function updateHitbox()
	{
		super.updateHitbox();
		if (autoAdjustOffset)
		{
			offset.x = iconOffsets[0];
			offset.y = iconOffsets[1];
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
