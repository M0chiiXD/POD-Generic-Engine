import funkin.options.type.Checkbox;
// TODO: make the options things work!!
var phant = Paths.font("PhantomMuff.ttf");
var text:String;
var wavy= new CustomShader("waterDistortion");
var timer = 0;
var totalTimer:Float = FlxG.random.float(100, 1000);
var options:Array=[];
var objects:Array=[];

function create(){
	warnbg = new FlxSprite();
	warnbg.loadGraphic(Paths.image("menus/warningBG"));
	warnbg.scale.set(FlxG.width / warnbg.width, FlxG.height / warnbg.height);
	warnbg.scrollFactor.set();
	warnbg.updateHitbox();
	warnbg.shader = wavy;
	warnbg.alpha = 0.1;
	add(warnbg);

	wavy.strength = 1;

	warningTitle = new FlxText(0, 95, 920, "WARNING");
	warningTitle.setFormat(phant, 75, FlxColor.RED, "center");
	warningTitle.scrollFactor.set(0, 0);
	warningTitle.updateHitbox();
	warningTitle.screenCenter(0x01);
	add(warningTitle);

	warningText1 = new FlxText(0, 226, 1500, "This mod contains:");
	warningText1.setFormat(phant, 34, FlxColor.WHITE, "center");
	warningText1.scrollFactor.set(0, 0);
	warningText1.updateHitbox();
	warningText1.screenCenter(0x01);
	add(warningText1);

	warningEndText = new FlxText(0, 550, 1000, "Press Enter to continue");
	warningEndText.setFormat(phant, 38, FlxColor.RED, "center");
	warningEndText.scrollFactor.set(0, 0);
	warningEndText.updateHitbox();
	warningEndText.screenCenter(0x01);
	add(warningEndText);

	optionsCamera = new FlxCamera();
	optionsCamera.zoom = 0.65;
	optionsCamera.bgColor = 0x00000000;
	FlxG.cameras.add(optionsCamera, false);

	option1=new Checkbox("Flashing lights");
	option2=new Checkbox("Loud and/or triggering noises");
	option3=new Checkbox("Minor jumpscares");
	option4=new Checkbox("Copious amounts of camera shaking");
	option5=new Checkbox("some amount of Copyrighted Material");
	option6=new Checkbox("A checkbox option with a relatively long label");

	for(i in[option1,option2,option3,option4,option5,option6]){
		i.visible = false;
		i.camera = optionsCamera;
		add(i);
		options.push(i);
	}

	objects=options.concat([warningTitle,warningText1,warningEndText,warnbg]);

	warningTitle.y -= 100;
	warningText1.alpha = 0;
	warningEndText.y += 100;

	curWarnSwitch(0);
}

function postCreate() {
	CoolUtil.playMusic(Paths.music("warning pod ahead"));
	FlxG.sound.music.fadeIn(2, 0, 0.8);
}

var curWarn:Int = 0;
function update(elapsed:Float){
	warningText1.text = text;

	warningTitle.alpha = warningEndText.alpha;

	if (controls.ACCEPT) {
		curWarn = FlxMath.wrap(curWarn + 1, 0, 4);
		FlxG.sound.play(Paths.sound("freeplay/scroll"));
		curWarnSwitch(curWarn);
	}

	if (controls.BACK && curWarn != 0) {
		curWarn = FlxMath.wrap(curWarn - 1, 0, 3);
		FlxG.sound.play(Paths.sound("freeplay/scroll"));
		curWarnSwitch(curWarn);
	}

	wavy?.time = (totalTimer += elapsed);
}

function curWarnSwitch(swap:Int){
	switch (swap) {
		case 0: triggerMenu1();
		case 1: triggerMenu2();
		case 2: triggerMenu3();
		case 3: triggerMenuEnd();
	}
}

function triggerMenu1() {
	text = "This mod contains:\n\nFlashing lights, Loud and/or triggering noises,\nMinor jumpscares, Copious amounts of camera shaking,\nand some amount of Copyrighted Material";
	for(o in objects)FlxTween.cancelTweensOf(o);
	FlxTween.tween(warningTitle, {y: 95}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {alpha: 1}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {y: 226}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {alpha: 1, y: 550}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warnbg, {alpha: 0.15}, 0.5, {ease: FlxEase.quartIn});
	for(i=>o in options)FlxTween.tween(o, {x: (i % 2) == 0 ? -o.width - (FlxG.width * (1 - optionsCamera.zoom)) : (FlxG.width * (2 - optionsCamera.zoom)), y: 425 + (199 * 0.5)}, 0.8, {ease: FlxEase.quartOut, onComplete: _ -> {o.visible = false;}});
	warningEndText.text = "Press ACCEPT to continue";
}

function triggerMenu2() {
	text = "If you'd like to change these settings,\nyou may adjust them below:";
	for(o in objects)FlxTween.cancelTweensOf(o);
	FlxTween.tween(warningTitle, {y: 95 - 65}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {y: 226 - 110}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {y: 550 + 86}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {alpha: 1}, 0.5, {ease: FlxEase.quartIn});
	FlxTween.tween(warnbg, {alpha: 0.1}, 0.5, {ease: FlxEase.quartIn});
	for(i=>o in options){
		o.visible = true;
		o.setPosition((i % 2) == (controls.BACK?1:0) ? -o.width - (FlxG.width * (1 - optionsCamera.zoom)) : (FlxG.width * (2 - optionsCamera.zoom)), (226 * optionsCamera.zoom) + (100 * i));
		FlxTween.tween(o, {x: (FlxG.width - o.width) * 0.5}, 1, {ease: FlxEase.quartOut, startDelay: i * 0.125});
	}
	warningEndText.text = "Press ACCEPT to continue, BACK to return";
}

function triggerMenu3() {
	text = "With that done, press\nACCEPT to start playing!";
	for(o in objects)FlxTween.cancelTweensOf(o);
	FlxTween.tween(warningTitle, {y: warningTitle.y + 48}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {y: warningText1.y + 170}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {y: warningEndText.y - 86}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warnbg, {alpha: 0}, 0.8, {ease: FlxEase.quartIn});
	FlxTween.tween(warningEndText, {alpha: 0}, 0.8, {ease: FlxEase.quartOut});
	for(i=>o in options)FlxTween.tween(o, {x: (i % 2) == 1 ? -o.width - (FlxG.width * (1 - optionsCamera.zoom)) : (FlxG.width * (2 - optionsCamera.zoom)), y: 401}, 1, {ease: FlxEase.quartOut, onComplete: _ -> {o.visible = false;}, startDelay: i * 0.015625/*(1÷64)*/});
}

function triggerMenuEnd() {
	//ill add stuff soon
	FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.3 }, 0.8);
	FlxG.switchState(new ModState("SplashState"));
}