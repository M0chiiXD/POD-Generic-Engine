import openfl.Lib;
import openfl.utils.Assets;
import openfl.display.BlendMode;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;

import funkin.backend.MusicBeatState;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.backend.utils.DiscordUtil;

import Date;

import OutlineModifier; //thank you LJ

var bgCam:FlxCamera = new FlxCamera();
var gameCam:FlxCamera = new FlxCamera();
var transitionCam:FlxCamera = new FlxCamera();

var menuBtns:Array<String> = [];
var outlineGrp:Array = [];
var sureDid:Array = CoolUtil.coolTextFile("data/config/introText.txt");
var selectIndex:Int = -1;

var transitioning:Bool = false;
var menuActive:Bool = false;
var skybox:FlxSprite;
var logo:FlxSprite;
var scrollSFX:FlxSound;

var today = Date.now();
var month = today.getMonth() + 1;

var outline:CustomShader = new CustomShader("outline2");
public static var lastMenu:String;

function create() {
	DiscordUtil.call('onMenuLoaded', ['on main menu']);
	
	menuActive = false;
	transitioning = true;

	bgCam.bgColor = 0x00000000;
    gameCam.bgColor = 0x00000000;
	transitionCam.bgColor = 0x00000000;
    bgCam.useBgAlphaBlending = true;
    gameCam.useBgAlphaBlending = true;
	transitionCam.useBgAlphaBlending = true;

    FlxG.cameras.add(bgCam, false);
    FlxG.cameras.add(gameCam, false);
	FlxG.cameras.add(transitionCam, false);

	FlxG.mouse.visible = true;
	FlxG.mouse.enabled = true;

	scrollSFX = FlxG.sound.load(Paths.sound('menu/scroll'));
	
	skybox = new FlxSprite(0, -360).loadGraphic(Paths.image('menus/mainmenu/menuBG/skybox'));
	skybox.scale.set(2, 2);
	skybox.alpha = 0.75;
	skybox.camera = bgCam;
	
	fog1 = new FlxBackdrop(Paths.image('menus/mainmenu/menuBG/fog1'), FlxAxes.X);
	fog1.velocity.x = 380;
	fog1.scrollFactor.set(0.8, 1);
	
	fog2 = new FlxBackdrop(Paths.image('menus/mainmenu/menuBG/fog2'), FlxAxes.X);
	fog2.velocity.x = -320;
	fog2.scrollFactor.set(0.8, 1);
	
	fog3 = new FlxBackdrop(Paths.image('menus/mainmenu/menuBG/fog2'), FlxAxes.X);
	fog3.velocity.x = 250;
	fog3.scrollFactor.set(0.8, 1);
	
	fog1.camera = fog2.camera = fog3.camera = bgCam;	
	fog1.y = fog2.y = fog3.y = -1000;
	
	hills = new FlxSprite(0, -735).loadGraphic(Paths.image('menus/mainmenu/menuBG/hills'));
	hills.setGraphicSize(FlxG.width, FlxG.height * 2);
	hills.updateHitbox();
	hills.scrollFactor.set(1.05, 1);
	hills.antialiasing= Options.antialiasing;
	hills.camera = bgCam;
	
	floor = new FlxSprite(0, -720).loadGraphic(Paths.image('menus/mainmenu/menuBG/floor'));
	floor.setGraphicSize(FlxG.width, FlxG.height * 2);
	floor.updateHitbox();
	floor.scrollFactor.set(0.8, 0.85);
	floor.antialiasing= Options.antialiasing;
	floor.camera = bgCam;
	
	rockLock = new FlxTypedEmitter(-100, 800, 40);
	rockLock.keepScaleRatio = true;
	rockLock.angle.set(5, 8, 10, 26, 80, 12);
	rockLock.angularVelocity.set(-10, 5);
	rockLock.scale.set(0.96, 0.96, 1.12, 1.12, 1.1, 1.1, 0.85, 0.85);
	rockLock.launchAngle.set(-90, -90);
	rockLock.lifespan.set(12, 15);
	rockLock.speed.set(520, 550);
	rockLock.width = FlxG.width;
	rockLock.camera = bgCam;
	for (i in 0...500) {
		var particle = new FlxParticle();
		particle.loadGraphic(Paths.image("menus/mainmenu/menuBG/rocks/rock" + FlxG.random.int(1, 5)));
		particle.scrollFactor(1.5, 1);
		rockLock.add(particle);
	}
	rockLock.start(false, 1, 0);
	
	rightBuildings = new FlxSprite(1, -720).loadGraphic(Paths.image('menus/mainmenu/menuBG/rightBuilding'));
	rightBuildings.setGraphicSize(FlxG.width, FlxG.height * 2);
	rightBuildings.updateHitbox();
	rightBuildings.scrollFactor.set(0.8, 0.95);
	rightBuildings.antialiasing= Options.antialiasing;
	rightBuildings.camera = bgCam;
	
	leftBuilding = new FlxSprite(-1, -720).loadGraphic(Paths.image('menus/mainmenu/menuBG/leftBuilding'));
	leftBuilding.setGraphicSize(FlxG.width, FlxG.height * 2);
	leftBuilding.updateHitbox();
	leftBuilding.scrollFactor.set(0.8, 0.95);
	leftBuilding.antialiasing= Options.antialiasing;
	leftBuilding.camera = bgCam;

	clouds = new FlxSprite(-1, -720).loadGraphic(Paths.image('menus/mainmenu/menuBG/clouds'));
	clouds.setGraphicSize(FlxG.width, FlxG.height * 2.5);
	clouds.updateHitbox();
	clouds.alpha = 0.155;
	clouds.blend = BlendMode.ADD;
	clouds.scrollFactor.set(0.8, 0.95);
	clouds.antialiasing= Options.antialiasing;
	clouds.camera = bgCam;
	
	skybeam = new FunkinSprite(-40, -960, Paths.image('menus/mainmenu/menuBG/menu_beam'));
	skybeam.angle = -0.68;
 	skybeam.scale.set(0.72, 0.72);
	skybeam.addAnim("beam", "beam", 8, true);
	skybeam.updateHitbox();
	skybeam.camera = bgCam;
	skybeam.antialiasing= Options.antialiasing;
	skybeam.scrollFactor.set(0.5, 0.85);
	skybeam.playAnim("beam");

	add(skybox);
	add(fog1);
	add(fog2);
	add(fog3);
	add(hills);

	var isles = [
		isle1 = makeIsland("1", 160, -440),
		isle2 = makeIsland("2", 820, -330),
		isle3 = makeIsland("3", 860, -600),
		isle4 = makeIsland("4", 240, -750),
		isle5 = makeIsland("5", 368, -580),
		isle6 = makeIsland("6", 790, -780)
	];

	for (h in isles) h.camera = bgCam;
	for (h in 0...isles.length) {
		FlxTween.tween(isles[h], {x: isles[h].x - 12}, FlxG.random.int(2, 2.58) * (0.0 + h), {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
		FlxTween.tween(isles[h], {y: isles[h].y - 15}, FlxG.random.int(2, 2.3) + (0.0 + h), {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	}

	FlxTween.tween(clouds, {x: clouds.x - 12}, 1.5, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(clouds, {y: clouds.y - 15}, 1.6, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

	add(skybeam);
	add(rockLock);
	add(clouds);
	add(floor);
	add(rightBuildings);
	add(leftBuilding);

	logo = new FlxSprite();
	if (month == 6) logo.loadGraphic(Paths.image('menus/titlescreen/gayTitle'));
	else logo.loadGraphic(Paths.image('menus/titlescreen/doomTitle'));
	logo.scale.set(1.40, 1.40);
	logo.updateHitbox();
	logo.x = (FlxG.width - logo.width) / 2;
	logo.scrollFactor.set();
	logo.antialiasing= Options.antialiasing;
	logo.camera = gameCam;
	add(logo);
	
	introtxt = new FunkinText(0, 0, 600, sureDid[FlxG.random.int(0, sureDid.length - 1)], 35, true);
	introtxt.font = Paths.font("Packer-Regular.otf");
	introtxt.alignment = "center";
	introtxt.scrollFactor.set();
	introtxt.updateHitbox();
	introtxt.antialiasing= Options.antialiasing;
	introtxt.angle = -8;
	introtxt.camera = gameCam;
	add(introtxt);
	
	menuBtns = [
        makeButton(480, 30, "play"),
		makeButton(780, 160, "freeplay"),
		makeButton(430, 430, "credits"),
		makeButton(110, 200, "gallery"),
		makeButton(980, 400, "settings")
    ];
	
	for (i in menuBtns) {
		i.y = i.y - 700;
		i.camera = gameCam;
	}
	
	//intro setup
	bgCam.scroll.y = -844;
	bgCam.zoom = 1.5;
	FlxTween.tween(bgCam, {"scroll.y": 0, zoom: 1.05}, 1.35, {ease: FlxEase.quintOut});
	logo.y -= 700;
	FlxTween.tween(logo, {y: (FlxG.height - logo.height) / 2}, 2, {ease: FlxEase.expoOut, 
	onComplete: (_) -> transitioning = false });
	lastMenu = "MainMenu";
}

var scale:Int = 0.45;
var bOutline:OutlineModifier;
function makeButton(xBtn:Float, yBtn:Float, text:String) {
	var b = new FunkinSprite(xBtn, yBtn, Paths.image("menus/mainmenu/menubuttons"));
	b.animation.addByPrefix("idle", "menubuttons " + text + "idle", 5, true);
	b.animation.addByPrefix("select","menubuttons " + text + "select", 8, false);
	b.setGraphicSize(180, 180);
	b.antialiasing = Options.antialiasing;
	b.updateHitbox();
	b.scrollFactor.set(0.8, 0.8);
	b.alpha = 1;
    add(b);
	b.playAnim("idle");
    return b;
}

function makeIsland(num:String, posX:Int, posY:Int) {
	var isle = new FlxSprite(posX, posY).loadGraphic(Paths.image('menus/mainmenu/menuBG/islands/island' + num));
	isle.antialiasing = Options.antialiasing;
	isle.scale.set(0.5, 0.5);
	isle.scrollFactor.set(0.8, 0.95);
	isle.updateHitbox();
	add(isle);
	return(isle);
}

var rockLock:FlxTypedEmitter<FlxParticle>;
function postCreate() {
	CoolUtil.playMusic(Paths.music("freakyMenu"), false);
	
	fog1.blend = fog2.blend = fog3.blend = BlendMode.HARDLIGHT;
	
	for (i in 0...menuBtns.length) {
		outline = new OutlineModifier(menuBtns[i], FlxColor.WHITE);
		outlineGrp.push(outline);
		insert(0, outline);
	}
}

function beatHit(){
	introtxt.scale.set(0.91, 0.9);
	logo.scale.set(1.35, 1.35);
}

var highlight:Int = -1;
function update(elapsed:Float) {
    if (controls.DEV_ACCESS && Options.devMode) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(new EditorPicker());
    }
	
	if (controls.ACCEPT && !menuActive && !transitioning) {
		FlxG.sound.play(Paths.sound("menu/confirm"));
		openMenu();
	}
	
	if (controls.BACK && menuActive && !transitioning) {
        FlxG.sound.play(Paths.sound("menu/cancel"));
		closeMenu();
    }
	
	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}
	
	if (FlxG.keys.justPressed.EIGHT) {
        FlxG.switchState(new ModState("Sigmavator"));
    }
	
	introtxt.setPosition(logo.x + 160, logo.y + 460);
	introtxt.scale.set(lerp(introtxt.scale.x, 0.88, 0.05), lerp(introtxt.scale.y, 0.88, 0.03));
	logo.scale.set(lerp(logo.scale.x, 1.3, 0.08), lerp(logo.scale.y, 1.3, 0.08));
	
//	updateVFX(elapsed);
	
	if (CoolUtil.mouseOverlaps(introtxt, gameCam) && !transitioning)
		if (FlxG.mouse.justPressed)
			introtxt.text = sureDid[FlxG.random.int(0, sureDid.length - 1)];
			
	if (FlxG.keys.justPressed.P && !transitioning && !menuActive){
		FlxTween.cancelTweensOf(logo);
		logo.angle = 0;
		FlxG.sound.play(Paths.sound("menu/spinlog"), 0.6);
		FlxTween.tween(logo, {angle: 360}, 1, {ease: FlxEase.quartOut});
	}
	
	for (i in 0...menuBtns.length) {
		for (i in 0...outlineGrp.length) {
			if (FlxG.mouse.overlaps(menuBtns[i]) && !transitioning) {
				menuBtns[i].scale.set(scale + .01, scale + .01);
				menuBtns[i].angle = 2.3; //where is 2.3 robtop
				outlineGrp[i].active = true;
				selectIndex = i;
					if (FlxG.mouse.justPressed && menuActive) {
						transitioning = true;
						menuBtns[selectIndex].playAnim("select");
						FlxG.sound.play(Paths.sound("menu/confirm"));
						tweenMenuBtns(selectIndex);
						FlxTween.tween(gameCam, {zoom: 1.3}, 1.2, {ease: FlxEase.quartInOut});
						FlxTween.tween(bgCam, {zoom: 1.5}, 1, {ease: FlxEase.quartInOut});
						FlxTween.tween(bgCam, {angle: 240}, 2, {ease: FlxEase.circIn});
						new FlxTimer().start(0.6, ()->{ selectOption(selectIndex); });
					}
					if (highlight != i) {
						FlxG.sound.play(Paths.sound('menu/scroll'));
						highlight = i;
					}
			} else {
				menuBtns[i].scale.x = lerp(menuBtns[i].scale.x, scale, 0.1);
				menuBtns[i].scale.y = lerp(menuBtns[i].scale.y, scale, 0.1);
				menuBtns[i].angle = 0;
				outlineGrp[i].active = false;
			}
		}
	}
}

function openMenu() {
	transitioning = true;
	FlxTween.cancelTweensOf(logo);
	FlxTween.tween(logo, {y: logo.y + 800}, 0.8, {ease: FlxEase.quartOut});
	for (i in 0...menuBtns.length)
		FlxTween.tween(menuBtns[i], {y: menuBtns[i].y + 712}, 1 + i * 0.035, {ease: FlxEase.quartOut});
	FlxTween.tween(bgCam, {"scroll.y": -900}, 1, {ease: FlxEase.quartOut});
	new FlxTimer().start(1, function(tmr:FlxTimer){ transitioning = false; });
	skybox.alpha = 1;
	FlxTween.tween(skybox, {alpha: 0.75}, 1, {ease: FlxEase.circOut});
	menuActive = true;
}

function closeMenu() {
	transitioning = true;
	FlxTween.tween(logo, {y: (FlxG.height - logo.height) / 2}, 1.1, {ease: FlxEase.quartOut});
	for (i in 0...menuBtns.length)
		FlxTween.tween(menuBtns[i], {y: menuBtns[i].y - 710}, 0.6 + i * 0.075, {ease: FlxEase.quartOut});
	FlxTween.tween(bgCam, {"scroll.y": 0}, 1, {ease: FlxEase.quartOut});
	new FlxTimer().start(1, function(tmr:FlxTimer){ transitioning = false; });
	menuActive = false;
}

function tweenMenuBtns(elapsed:Float) {
	for (i in 0...menuBtns.length) {		
		menuBtns[i].alpha = 0;
		FlxTween.cancelTweensOf(menuBtns[selectIndex]);
		FlxTween.tween(menuBtns[selectIndex], {
			x: (FlxG.width - 180) * 0.5,
			y: (FlxG.height - 180) * 0.5}, 1.15, {ease: FlxEase.expoOut});
		menuBtns[selectIndex].alpha = 1;
	}
}

function selectOption(index:Int){
    var fade = new FlxSprite(0, -720);
    fade.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    fade.alpha = 1;
    fade.scrollFactor.set();
	fade.camera = transitionCam;
    add(fade);
	
	FlxG.sound.music.fadeOut(1, 0, 0.8);	
	FlxTween.tween(fade, {y: 0}, 1, {ease: FlxEase.quintOut, onComplete: (_) -> {
			switch (index) {
				case 0: FlxG.switchState(new StoryMenuState());
				case 1: FlxG.switchState(new FreeplayState());
				case 2: FlxG.switchState(new CreditsMain()); 
				case 3: FlxG.switchState(new ModState("PODGallery")); 
				case 4: FlxG.switchState(new OptionsMenu());
			}
		}
	});
}
