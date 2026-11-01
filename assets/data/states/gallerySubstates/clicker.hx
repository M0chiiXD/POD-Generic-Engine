import flixel.FlxCamera;
import flixel.text.FlxText.FlxTextBorderStyle;

var trans:Bool = false;

var clickie:FlxSprite;

function create() {
	
	appBG = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/clicker/cookiebg'));
	appBG.setGraphicSize(this,width, this.height);
	appBG.scrollFactor.set();
	appBG.updateHitbox();
	add(appBG);
	
	clickie = new FlxSprite(0, 300).loadGraphic(Paths.image('menus/gallery/clicker/cooki'));
    clickie.scale.set(0.15, 0.15);
    clickie.updateHitbox();
    windowCenter(clickie);
    add(clickie);
	
	clickstxt = new FunkinText(0, 80, 400, "", 65, true);
	clickstxt.font = Paths.font("Packer-Regular.otf");
	clickstxt.borderSize = 2;
	clickstxt.screenCenter(0x01);
	clickstxt.alignment = "center";
	add(clickstxt);
	
	exit = new FlxSprite(FlxG.width - 53, 5).loadGraphic(Paths.image('menus/gallery/close'));
	exit.setGraphicSize(20, 20);
	exit.alpha = 0.8;
	exit.updateHitbox();
	add(exit);
}

public static var clickCount:Int = 0;
var bot = Paths.font("vcr.ttf");

function update(elapsed:Float) {
	if (exit == null) return;
	if (FlxG.mouse.overlaps(exit) && !trans) {
		exit.alpha = 1;
		if (FlxG.mouse.justPressed) {
			closing = true;
			FlxG.sound.play(Paths.sound("gallery/click"));
			closeWindow();
		}
	} else {
		exit.alpha = lerp(exit.alpha, 0.8, 0.1);
	}
	
	if (clickie == null) return;
	if (FlxG.mouse.overlaps(clickie) && FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("gallery/click"));
		clickie.scale.set(0.235, 0.235);
		new FlxTimer().start(0.1, ()->{clickCount++;});
	}
	
	clickie.scale.x = lerp(clickie.scale.x, 0.225, 0.2);
	clickie.scale.y = lerp(clickie.scale.y, 0.225, 0.2);
	
	clickstxt.text = "Your Clicks: " + clickCount;
}

function closeWindow() {
	new FlxTimer().start(0.1, ()->{ close(); });
}
