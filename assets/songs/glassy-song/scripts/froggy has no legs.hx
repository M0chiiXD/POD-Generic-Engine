import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxColor;

var camTitle:FlxCamera;
var titlecard:FlxSprite;

var shafer:CustomShader = new CustomShader("adjustColor");

var bg = stage.getSprite("sky");
var sun = stage.getSprite("sun");

// MORE events will be coded laterrrrrrhhkskj

function create() {
	camGame.addShader(shafer);

	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("stages/glassy/episode5.5"));
	titlecard.x = 275;
    titlecard.y = 0;
	titlecard.scale.set(0.35, 0.35);
	titlecard.updateHitbox();
    titlecard.cameras = [camHUD];
	
    darkener = new FlxSprite();
    darkener.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	darkener.screenCenter();
    darkener.cameras = [camHUD];
	add(darkener);
	add(titlecard);

	bgNight = new FlxSprite(bg.x, bg.y).makeGraphic(bg.width, bg.height, 0xFF2b105e);
	insert(0, bgNight);
	
	titlecard.scale.set(0.17, 0.17);
	titlecard.alpha = 0;
}

function postCreate() {
	camHUD.zoom = 2;
	
	for (i in 0...cpuStrums.members.length) {
		var glassyStrum = cpuStrums.members[i];
		glassyStrum.x -= 600;
	}
	for (i in 0...playerStrums.members.length) {
		var bfStrum = playerStrums.members[i];
		bfStrum.x -= 330;
	}
}

var bassDrop:Bool = false;
function update() {
	if (bassDrop) {
		camGame.width = 1280;
		camGame.height =  720;
		camGame.targetOffset.x = 0;
		camGame.x = 0;
	} else {
		camGame.width = 718;
		camGame.height =  718;
		camGame.targetOffset.x = 275;
		camGame.x = 275;
	}
}

function onSongStart() {
	FlxTween.tween(titlecard, {alpha: 1}, 3, {ease: FlxEase.cubeOut});
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 64:
			titlecard.visible = false;
			titlecard.exists = false;
			darkener.exists = false;
		case 384:
			bassDrop = true;
			for (i in 0...playerStrums.members.length) {
				var bfStrum = playerStrums.members[i];
				FlxTween.tween(bfStrum, {x: bfStrum.x + 330}, 1, {ease: FlxEase.cubeOut});
			}
			for (i in 0...cpuStrums.members.length) {
				var glassyStrum = cpuStrums.members[i];
				FlxTween.tween(glassyStrum, {x: glassyStrum.x + 600}, 1, {ease: FlxEase.cubeOut});
			}
			sunset(35);
		case 436:
			sun.scale.set(0.7, 0.7);
			FlxTween.tween(sun, {y: sun.y + 2900}, 42);
		case 488:
			FlxTween.tween(sun, {x: sun.x - 580, "scale.x": 0.5, "scale.y": 0.5}, 28);
		case 1536:
			bassDrop = false;
			for (i in 0...playerStrums.members.length) {
				var bfStrum = playerStrums.members[i];
				FlxTween.tween(bfStrum, {x: bfStrum.x - 330}, 1, {ease: FlxEase.cubeOut});
			}
			for (i in 0...cpuStrums.members.length) {
				var glassyStrum = cpuStrums.members[i];
				FlxTween.tween(glassyStrum, {x: glassyStrum.x - 600}, 1, {ease: FlxEase.cubeOut});
			}
	}
}

function sunset(time:Float) {
	FlxTween.color(null, time, bg.color, 0xffaf51, {
		ease: FlxEase.quadOut,
		onUpdate: (twn) -> {
			bg.color = twn.color;
		},
		onComplete: (_) -> { evening(35); }
	});
	FlxTween.num(0, -18, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.hue = val; });
	FlxTween.num(0, -15, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.saturation = val; });
	FlxTween.num(0, 1, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.contrast = val; });
	FlxTween.num(0, -25, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.brightness = val; });
}

function evening(time:Float) {
	FlxTween.tween(bg, {alpha: 0}, time);
	FlxTween.num(-18, -35, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.hue = val; });
	FlxTween.num(-15, -25, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.saturation = val; });
	FlxTween.num(1, 2.5, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.contrast = val; });
	FlxTween.num(-25, -50, time, {ease: FlxEase.quadIn}, (val:Float) -> { shafer.brightness = val; });
}

