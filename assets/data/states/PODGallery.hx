import openfl.Lib;
import openfl.filters.BlurFilter;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import funkin.options.OptionsMenu;
import Date;
import DateTools;
import flixel.FlxLayer;
import curtainsOS.BasicWindow;

var bg:FlxSprite;
var taskbar:FlxSprite;
var clock:FlxText;
var loadScreen:FlxSprite;
var loadingCam:FlxCamera; // will utilize soon

var transitioning:Bool = false;
var iconDT:Array<String> = [];

var selectIndex:Int;

var curtainsBGM:Array<Dynamic> = ["orbindos", "a new", "dream lofi", "nice mean"];

var curWindow;
var windowArray:Array<Dynamic> = [];
var windowList:FlxTypedGroup = new FlxSpriteGroup();
var windowStack:Array = [];
var windowLayer:FlxLayer;

public static var lastMenu:String;
public static var justPlayed:Bool;
public var theme = "bubbly";

function create() {
	lastMenu = "Gallery";
	justPlayed = false;

    FlxG.mouse.visible = true;

	bg = new FlxSprite();
	setWallpaper();
	bg.setGraphicSize(FlxG.width, FlxG.height);
	bg.updateHitbox();
    add(bg);

	iconDT = [
		makeIcon(20, 40, "trash", "Trash"),
		makeIcon(20, 130, "overloke", "Overloke"),
		makeIcon(20, 220, "metube", "MeTube"),
		makeIcon(20, 315, "cookie", "Cookie!"),
		makeIcon(1200, 40, "baldi", "Baldi"),
	];

	/* iconTB = [
	makeTaskbarIcon(10, FlxG.height - 80, "curtainsOS"),
	makeTaskbarIcon(120, FlxG.height - 80, "settings")
	]; */

	add(windowList);

	appHover = new FlxSprite(0, 0).makeGraphic(80, 80, 0xFF0066cc);
	appHover.alpha = 0.5;
	appHover.scrollFactor.set();
	insert(1, appHover);
	appHover.alpha = 0;

	taskbar = new FlxSprite(0, FlxG.height - 50).makeGraphic(FlxG.width, 50, FlxColor.BLACK);
	//taskbar.shader = blur;
	taskbar.scrollFactor.set();
	taskbar.alpha = 0.65;
	add(taskbar);

	startBase = new FlxSprite(10, FlxG.height - 75).makeGraphic(70, 70, FlxColor.TRANSPARENT, true);
	FlxSpriteUtil.drawRoundRectComplex(startBase, 0, 0, 70, 70, 20, 20, 20, 20, 0xFF6d9e9a, null, {smoothing: true});
	startBase.alpha = 0.5;
	add(startBase);

	start = new FlxSprite(15, FlxG.height - 70).loadGraphic(Paths.image('curtainsOS/logo'));
	start.setGraphicSize(60, 60);
	start.updateHitbox();
	add(start);

	clock = new FlxText(FlxG.width - 240, FlxG.height - 48, 250, "01:12");
	clock.setFormat(Paths.font("Segoe/Segoe UI.ttf"), 13.5, FlxColor.WHITE, "center");
	clock.scrollFactor.set(0, 0);
	clock.scale.set(1.3, 1.3);
	clock.updateHitbox();
    add(clock);

	playBGM(curtainsBGM[FlxG.random.int(0, curtainsBGM.length - 1)]);
	FlxG.sound.music.fadeIn(1.8, 0, 0.5);
	galleryOpen = true;
}

function playBGM(bgm:String) {
	CoolUtil.playMusic(Paths.music("curtainsbgm/" + bgm), false);
}

// might make the icons a class instead, idkkkkkk :b
function makeIcon(xBtn:Float, yBtn:Float, p:String, name:String) {
    var icon = new FlxSprite(xBtn, yBtn).loadGraphic(Paths.image('curtainsOS/apps/' + p));
	icon.scrollFactor.set(0, 0);
	icon.scale.set(0.6, 0.6);
	icon.updateHitbox();
    add(icon);

	var title = new FlxText(xBtn - 20, yBtn + 64, 170, name);
	title.setFormat(Paths.font("Segoe/Segoe UI.ttf"), 22, FlxColor.WHITE, "center");
	title.borderStyle = FlxTextBorderStyle.OUTLINE;
	title.borderColor = FlxColor.BLACK;
	title.borderSize = 1;
	title.scrollFactor.set(0, 0);
	title.scale.set(0.6, 0.6);
	title.updateHitbox();
    add(title);

    return icon;
    return title;
}

function makeTaskbarIcon(xBtn:Float, yBtn:Float, p:String) {
    var t = new FlxSprite().loadGraphic(Paths.image('curtainsOS/apps/' + p));
	t.scrollFactor.set(0, 0);
	t.setGraphicSize(80, 80);
	t.updateHitbox();
	t.x = xBtn;
	t.y = yBtn;
	t.alpha = 1;
    add(t);
    return t;
}

var galleryOpen = true;
var osDebug = true;

var openStartMenu = false;

public static var wallpaper:String = "aero";

var clicks = 0;
var hovered = false;
function postUpdate(elapsed:Float){
	clock.text = DateTools.format(Date.now(), "%H:%M %p\n%m/%d/%Y");

	if (FlxG.mouse.justPressed) FlxG.sound.play(Paths.sound("gallery/click"));

	//if (!galleryOpen) return;

	for (i in 0...iconDT.length) {
		if (FlxG.mouse.overlaps(iconDT[i])) {
			appHover.setPosition(iconDT[i].x + ((iconDT[i].width - 80) * 0.45), iconDT[i].y);
			if (selectIndex != i) clicks = 0;
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(appHover)) {
				hovered = true;
				selectIndex = i;
				if (i == 4) ding();
				else clicks++;
			}
			if (clicks == 2) {
				selectApp(selectIndex);
				clicks = 0;
			}
			if (clicks == 0) appHover.alpha = 0.2;
			else if (clicks > 0) appHover.alpha = 0.355;
		} else if (!FlxG.mouse.overlaps(appHover)) {
			if (dings != 0) dings = 0;
			clicks = 0;
			if (FlxG.mouse.justPressed) appHover.alpha = 0;
			hovered = false;
		}
	}

	//trackWindows();


	if (FlxG.mouse.overlaps(start) && !openStartMenu) {
		start.scale.x = 0.18;
		start.scale.y = 0.18;
		if (FlxG.mouse.justPressed) {
			openStartMenu = true;
		}
	} else if (!FlxG.mouse.overlaps(start) || openStartMenu) {
		start.scale.x = lerp(start.scale.x, 0.175, 0.15);
		start.scale.y = lerp(start.scale.y, 0.175, 0.15);
		if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(startBase)) {
			openStartMenu = false;
		}
	}

/*	for (i in 0...iconTB.length) {
        if (FlxG.mouse.overlaps(iconTB[i]) && !transitioning) {
			iconTB[i].scale.x = 0.62;
			iconTB[i].scale.y = 0.62;
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(iconTB[0])) {
					galleryShutdown();
				} else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(iconTB[1])) {
					persistentUpdate = !(persistentDraw = true);
					openSubState(new ModSubState("gallerySubstates/settings"));
				}
		} else {
			iconTB[i].scale.x = lerp(iconTB[i].scale.x, 0.6, 0.1);
			iconTB[i].scale.y = lerp(iconTB[i].scale.y, 0.6, 0.1);
			hovered = false;
		}
    }*/

	if (dings > 12) {
		PlayState.loadSong("greeeducation", "normal");
		FlxG.switchState(new PlayState());
	}

	if (controls.BACK) {
		FlxG.switchState(new MainMenuState());
	}

	if (osDebug) handleDebugControls();
}

function handleDebugControls() {
	if (FlxG.keys.justPressed.ONE) {
		theme = "aero";
		setWallpaper();
	} else if (FlxG.keys.justPressed.TWO) {
		theme = "epic";
		setWallpaper();
	} else if (FlxG.keys.justPressed.THREE) {
		theme = "bubbly";
		setWallpaper();
	} else if (FlxG.keys.justPressed.FIVE) {
		openStartMenu = false;
	} else if (FlxG.keys.justPressed.EIGHT) runWindow("applications/dialogtest", true);
}

/*function trackWindows() {
	for (i in 0...windowList.members.length) {
		if (windowList == null) return;
		if (FlxG.mouse.overlaps(windowList.members[i]) && FlxG.mouse.pressed) {
			dragWindow(windowList.members[i]);
		}
	}
}*/

function selectApp(index:Int){
	persistentUpdate = !(persistentDraw = true);
	switch (index) {
		case 0: runWindow("applications/trash");
		case 1: runWindow("applications/overloke");
		case 2: runWindow("applications/test2");
		case 3: runWindow("applications/clicker");
	}
}

function runWindow(path:String, ?dialog:Bool) {
	if (!dialog || dialog == null) var win = new BasicWindow(path, windowList);
	else var win = new BasicWindow(path, windowList, 300, 340);
	windowList.add(win);
	return(win);
}

function setWallpaper() {
	bg.loadGraphic(Paths.image("curtainsOS/themes/" + theme));
}

var dings:Int = 0;
function ding() {
	FlxG.sound.play(Paths.sound("gallery/baldi/punch"));
	FlxG.sound.play(Paths.sound("gallery/baldi/ow" + FlxG.random.int(1, 5)));
	FlxG.camera.shake(0.001, 0.1, null, true, FlxAxes.XY);
	dings++;
	trace("ding!", dings);
}
