package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class WazaSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Waza menu';
		rpcTitle = 'Waza menu'; //for Discord Rich Presence

		var option:Option = new Option('Enable Modchart',
			"Enables the modchart in waza pelicula\nActiva el modchart en waza pelicula\n\n(disable if ur a pussy)",
			'modchart',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('NPS Counter',
			"Enables a NPS counter before the score.\nActiva un contador de NPS antes del puntaje.",
			'npsCount',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ratings and Combo in the Hud',
			'Enable this to have the Ratings, Combo and MS in the Hud.\nActiva esto para tener los Ratings, Combo y MS en el HUD.',
			'ratinginHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Judgement Counter',
			"Shows a judgement counter at the left of the screen\nMuestra un contador de los Ratings\n\n\n(Sicks: 3, Goods:2, Bads: 1, 'Shits: 0)",
			'judgementCounter',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Character Colored Bars',
			'Enable this to make the\nTime and Health Bars Colored\nby the Character json Color\n\nActiva esto para que las barras de vida\ny tiempo esten coloreadas acorde al icono del personaje',
			'colorBars',
			'bool',
			false);
		addOption(option);

		super();
	}
}