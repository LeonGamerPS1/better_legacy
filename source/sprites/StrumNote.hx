package sprites;

import flixel.FlxSprite;

class StrumNote extends FlxSprite
{
	public var downScroll:Bool = false;

	public var resetAnim:Float = 0;

	public var cover:HoldCover;

	public function new(?x:Float = 0, ?y:Float = 0,id:Int = 0)
	{
		super(x, y);
		cover = new HoldCover(id, this);
		cover.visible = false;
	}

	public function playAnim(anim:String = "static", force:Bool = false)
	{
		animation.play(anim, force);

		centerOffsets();
		centerOrigin();
	}

	override function update(elapsed:Float)
	{
		if (resetAnim > 0)
		{
			resetAnim -= elapsed;
			if (resetAnim <= 0)
			{
				playAnim('static', true);
				resetAnim = 0;
			}
		}
		if (cover != null && cover.cameras != cameras)
			cover.cameras = cameras;

		super.update(elapsed);
	}

	override function draw()
	{
		super.draw();
		if (cover != null && cover.visible && cover.exists)
			cover.setPosition(x - width, (y - height) + Note.swagWidth / 7);
	}
}
