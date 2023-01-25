package;

import haxe.Http;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end

// only load this reference if its debug because its only needed for debug??? idk it might help with the file size or something 
#if debug
import openfl.net.FileReference;
import haxe.Json;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var fun:Int;
	var eye:FlxSprite;
	var loopEyeTween:FlxTween;

	var camBelow:FlxCamera;
	var camStupid:FlxCamera;
	var camDef:FlxCamera;

	override public function create():Void
	{
		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		#if desktop
		DiscordClient.initialize();
		#end

		super.create();

		#if (flixel < "5.0.0") FlxG.save.bind('funkin', 'ninjamuffin99'); #end

		SaveDataHandler.initSave();
		LanguageManager.init();

		Highscore.load();
		
		CoolUtil.init();

		Main.fpsVar.visible = !FlxG.save.data.disableFps;

		camBelow = new FlxCamera();
		camStupid = new FlxCamera();
		camDef = new FlxCamera();
		FlxG.cameras.add(camBelow);
		FlxG.cameras.add(camStupid);
		FlxG.cameras.add(camDef);
		camStupid.bgColor.alpha = 0;
		camDef.bgColor.alpha = 0;
		FlxCamera.defaultCameras = [camDef];

		CompatTool.initSave();
		if(CompatTool.save.data.compatMode == null)
        {
            FlxG.switchState(new CompatWarningState());
        }

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});		
		#end
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(-1, 0), {asset: diamond, width: 32, height: 32},
				new FlxRect(0, 0, FlxG.width * 2, FlxG.height * 2));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(1, 0),
				{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width * 2, FlxG.height * 2));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.cameras = [camBelow];
		add(bg);

		logoBl = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/gayest-logo', 'preload'));
		logoBl.antialiasing = true;
		logoBl.screenCenter();
		logoBl.updateHitbox();
		logoBl.scale.set(0.65, 0.65);
		logoBl.cameras = [camStupid];
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('ui/titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 18, false);
		titleText.screenCenter(X);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "MoldyGH\nMissingTextureMan101\nRapparep\nZmac\nTheBuilder\nT5mpler\nErizur", true);
		credTextShit.antialiasing = true;
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);

		// Init the first line of text on the intro start to prevent the intro text bug
		createCoolText(['Engine Created by:']);
		addMoreText('MoldyGH');
		addMoreText('MissingTextureMan101');
		addMoreText('Rapparep LOL');
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');

			camStupid.flash(FlxColor.WHITE, 0.5);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
			});
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		camStupid.zoom = FlxMath.lerp(1, camStupid.zoom, 0.95);

		super.update(elapsed);
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(credGroup);
			skippedIntro = true;
	
			camStupid.flash(FlxColor.WHITE, 0.5);
		}
	}


	override function beatHit()
	{
		if (logoBl != null)
		{
			super.beatHit();

			camStupid.zoom += 0.05;

			danceLeft = !danceLeft;
	
			switch (curBeat)
			{
				case 2:
					deleteCoolText();
				case 3:
					addMoreText('Hecho en');
				case 4:
					addMoreText('Dave Engine');
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['El mod mas insano']);
				case 7:
					addMoreText('creado por juanitofreefire');
					addMoreText('ztgds');
				case 8:
					deleteCoolText();
				case 9:
					createCoolText([curWacky[0]]);
				case 10:
					addMoreText(curWacky[1]);
				case 11:
					deleteCoolText();
				case 12:
					addMoreText("Gayest");
				case 13:
					addMoreText('Night');
				case 14:
					addMoreText("Funkin'");
				case 16:
					skipIntro();
			}
		}
	}

	// INTRO TEXT MANIPULATION SHIT

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.antialiasing = true;
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true);
		coolText.screenCenter(X);
		coolText.antialiasing = true;
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}
	
	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}
	
	function deleteOneCoolText()
	{
		credGroup.remove(textGroup.members[0], true);
		textGroup.remove(textGroup.members[0], true);
	}
}
