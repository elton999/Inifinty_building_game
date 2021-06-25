package ui;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class HUD
{
	public var timer:Float = 0;
	public var timerSecondsText:FlxText;
	public var timerMilisecondsText:FlxText;
	public var currentLevelText:FlxText;
	public var pointsTexts:FlxText;
	public var points:Int = 0;
	public var lifes:Int = 3;
	public var lifesText:FlxText;
	public var state:PlayState;

	public function new()
	{
		timerSecondsText = new FlxText();
		timerSecondsText.font = AssetPaths.KenneyMini__ttf;
		timerSecondsText.scrollFactor.set(0, 0);
		timerSecondsText.antialiasing = false;
		timerSecondsText.size = 12;

		timerMilisecondsText = new FlxText();
		timerMilisecondsText.font = AssetPaths.KenneyMini__ttf;
		timerMilisecondsText.scrollFactor.set(0, 0);
		timerMilisecondsText.setPosition(30, 4);

		currentLevelText = new FlxText();
		currentLevelText.font = AssetPaths.KenneyMini__ttf;
		currentLevelText.scrollFactor.set(0, 0);
		currentLevelText.setPosition(0, 12);
		currentLevelText.size = 15;

		pointsTexts = new FlxText();
		pointsTexts.font = AssetPaths.KenneyMini__ttf;
		pointsTexts.scrollFactor.set(0, 0);
		pointsTexts.setPosition(0, 26);
		pointsTexts.size = 15;

		lifesText = new FlxText();
		lifesText.font = AssetPaths.KenneyMini__ttf;
		lifesText.scrollFactor.set(0, 0);
		lifesText.setPosition(0, 40);
		lifesText.size = 15;
	}

	public function update(elapsed:Float)
	{
		if (this.lifes > 0)
			timer += elapsed;

		var preNumbers = "0";
		preNumbers = timer < 1000 ? "0" : preNumbers;
		preNumbers = timer < 100 ? "00" : preNumbers;
		preNumbers = timer < 10 ? "000" : preNumbers;

		timerSecondsText.text = preNumbers + Std.string(timer).split(".")[0];
		var miliseconds:String = Std.string(timer).split(".")[1];
		miliseconds = miliseconds == null ? "000" : miliseconds;
		timerMilisecondsText.text = "0";
		for (i in 0...3)
		{
			if (i < miliseconds.length)
				timerMilisecondsText.text += miliseconds.charAt(i);
			else
				timerMilisecondsText.text += "0";
		}

		timerMilisecondsText.text = "." + timerMilisecondsText.text;

		currentLevelText.text = "Floor: " + Std.string(this.state.currentLevel + 1);
		pointsTexts.text = "Points: " + Std.string(this.points);

		lifesText.text = Std.string(this.lifes) + "/3";
	}
}
