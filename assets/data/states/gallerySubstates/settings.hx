import flixel.FlxCamera;
import flixel.text.FlxText.FlxTextBorderStyle;

var windowCam = new FlxCamera(0, 0, width, height);
var appCam = new FlxCamera();

var trans:Bool = false;

var wallpapers:Array<String> = [];

var clickie:FlxSprite;

function create() {
	windowCam.bgColor = 0x88000000;
	windowCam.alpha = 1;
	windowCam.zoom = 0.5;
	
	appCam.alpha = 0;
	appCam.bgColor = 0;
	
	trans = true;
	
	windowBase = new FlxSprite(0, 0);
	windowBase.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	windowBase.alpha = 1;
	windowBase.scrollFactor.set();
	windowBase.updateHitbox();
	windowBase.cameras = [windowCam];
	add(windowBase);
	
	appBG = new FlxSprite(0, 0);
	appBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
	appBG.alpha = 1;
	appBG.scrollFactor.set();
	appBG.updateHitbox();
	appBG.cameras = [appCam];
	add(appBG);
		
	filestxt = new FlxText();
	filestxt.color = FlxColor.WHITE;
	filestxt.text = "Settings";
	filestxt.font = bot;
	filestxt.size = 40;
	filestxt.borderStyle = FlxTextBorderStyle.OUTLINE;
	filestxt.borderColor = FlxColor.BLACK;
	filestxt.borderSize = 2;
	filestxt.screenCenter();
	filestxt.y = 40;
	filestxt.cameras = [appCam];
	add(filestxt);
	
	exit = new FlxSprite(FlxG.width - 53, 5).loadGraphic(Paths.image('menus/gallery/close'));
	exit.setGraphicSize(50, 50);
	exit.alpha = 0.8;
	exit.updateHitbox();
	exit.camera = appCam;
	add(exit);
	
	FlxTween.tween(windowCam, {zoom: 1}, 0.5, {ease: FlxEase.cubeOut, onComplete: (_) -> 
		loadApp()
	});
}

var bot = Paths.font("vcr.ttf");
function postCreate() {
	cameras.push(windowCam);
	cameras.push(appCam);
}

function postUpdate(elapsed:Float) {
	if (FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("gallery/click"));
	}

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
}

function loadApp() {
	FlxTween.tween(appCam, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	trans = false;
}

function closeWindow() {
	appCam.alpha = 0;
	FlxTween.tween(windowCam, {alpha: 0}, 0.3, {ease: FlxEase.cubeOut});
	FlxTween.tween(windowCam, {zoom: 0.5}, 0.3, {ease: FlxEase.cubeOut, 
	onComplete: (_) -> close() });
}
