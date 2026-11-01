import flixel.text.FlxText;
import openfl.display.BlendMode;

var titlecard;
var rgbg:FlxSprite;

function onPostStrumCreation(event){
	if (event.player == 0) {
		event.strum.setPosition(30, 790);
		event.strum.scrollFactor.set(1, 1);
		event.strum.noteAngle = 
			switch (event.strum.ID) {
				case 0: 90;
				case 1: 0;
				case 2: 180;
				case 3: 270;
			}
		event.strum.alpha = 0;
	}
}

function create() {
	VideoUtil.load(["redarrowbegin"], [], camHUD);
	camHUD.fade(FlxColor.BLACK, 0, false);

	raDance = new FunkinSprite(40, 210, Paths.image("stages/pioraa/redarrowdance"));
	raDance.animation.addByPrefix("1", "redarrowdance animatic", 10, true);
	raDance.animation.addByPrefix("2", "redarrowdance bounce", 10, true);
	raDance.animation.addByPrefix("3", "redarrowdance floss", 10, true);
	raDance.animation.addByPrefix("4", "redarrowdance octo", 10, true);
	raDance.scale.set(0.65, 0.65);
	raDance.updateHitbox();
	raDance.camera = camHUD;
	insert(0, raDance);

	sbDance = new FunkinSprite(420, 230, Paths.image("stages/pioraa/speechbubbledance"));
	sbDance.animation.addByPrefix("1", "speechbubbledance dab", 10, true);
	sbDance.animation.addByPrefix("2", "speechbubbledance edd", 10, true);
	sbDance.animation.addByPrefix("3", "speechbubbledance hugo", 10, true);
	sbDance.animation.addByPrefix("4", "speechbubbledance spooky", 10, true);
	sbDance.scale.set(0.56, 0.56);
	sbDance.updateHitbox();
	sbDance.camera = camHUD;
	insert(0, sbDance);

	rgbg = new FlxSprite().makeGraphic(camHUD.width, camHUD.height, FlxColor.WHITE);
	rgbg.camera = camHUD;
	rgbg.visible = false;
	insert(0, rgbg); 
}

var limitAdder:Float = 1400;
function postCreate() {
	titlecard = new FlxSprite(0, 100).loadGraphic(Paths.image("game/titlecards/redandarrow_titlecard"));
	CoolUtil.cameraCenter(titlecard, camHUD, FlxAxes.X);
    titlecard.alpha = 0;
	titlecard.scale.set(1.2, 1,2);
    titlecard.camera = camHUD;
    insert(0, titlecard);
	
	// stupid
	if ((dadNotes = strumLines?.members[0]) != null) {
		dadNotes.notes.limit += limitAdder;
		dadNotes.camera = camGame;
		remove(strumLines);
		insert(members.indexOf(dad), strumLines);
	}
}

function onNoteCreation(note)
	if (note.strumLineID == 0) {
		note.noteScale = 2.3;
		note.noteSprite = "game/notes/redArrowNotes";
}

function onDadHit() glowRedArrow();

function onSongStart() {
	new FlxTimer().start(0.3, function(tmr:FlxTimer){
		camHUD.fade(FlxColor.BLACK, 8, true);
		VideoUtil.playNext(0);
	});
}

//i hate rgb -megas
var hue:Float = 0;
var itsrgbTime:Bool = false;
// ill fix this laterrrgggghhhhhhh -myra
function update(elapsed:Float) {
    var bg = stage.getSprite("sky");
    if (itsrgbTime) {
        hue += elapsed * 500;
        if (hue >= 360)
            hue -= 360;
        bg.color = FlxColor.fromHSB(Std.int(hue), 1, 1);
    } else {
		bg.color = FlxColor.fromHSB(Std.int(hue), 0, 1);
    }

    raDance.visible = sbDance.visible = rgbg.visible;
}

function stepHit(curStep:Int) {
	switch (curStep){
		case 192:
			VideoUtil.destroyCur();
			FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
			FlxTween.tween(titlecard.scale, {x: 1.5, y: 1.5}, 1, {ease: FlxEase.bounceOut});
		case 214:
			FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		case 768: itsrgbTime = true;
		case 1024: itsrgbTime = false;
		case 1786:
			for (i in 0...playerStrums.members.length) {
				var coolios = playerStrums.members[i];
				FlxTween.tween(coolios, {x: coolios.x - 260}, 1, {ease: FlxEase.circInOut});
			}

			fade = new FlxSprite(0, -720).makeGraphic(camHUD.width, camHUD.height, 0xFF000000);
			fade.camera = camHUD;
			insert(0, fade);
			FlxTween.tween(fade, {y: 0}, 1, {ease: FlxEase.quintOut});
		case 1792:
			fade.kill();
			camGame.visible = false;
			rgbg.visible = true;
			lesGo = true;
			littleGuysDance();
		case 1820: showLittleGuys();
		case 1824: littleGuysDance();
		case 1852: showLittleGuys();
		case 1858: littleGuysDance();
		case 1884: showLittleGuys();
		case 1888: littleGuysDance();
		case 1920: littleGuysDance();
		case 1948: showLittleGuys();
		case 1952: littleGuysDance();
		case 1980: showLittleGuys();
		case 1984: littleGuysDance();
		case 2012: showLittleGuys();
		case 2016: littleGuysDance();
		case 2048:
			camGame.visible = true;
			rgbg.visible = false;
			lesGo = false;
			showLittleGuys();
			for (i in 0...playerStrums.members.length) {
				var coolios = playerStrums.members[i];
				FlxTween.tween(coolios, {x: coolios.x + 260}, 0.8, {ease: FlxEase.quadOut});
			}
    }
}

var colorMap:Array = [0xFFFF00FF, 0xFF00FFFF, 0xFFFFFF00, 0xFF008000, 0xFF800080];
var curColor:Int = 0;
var lesGo:Bool = false;
function beatHit() {
	if (!lesGo) return;
	curColor = FlxG.random.int(0, colorMap.length - 1, [curColor]);
	rgbg.color = colorMap[curColor];
}

function showLittleGuys(?bool:Bool) {
	rgbg.visible = (bool == null) ? false : bool;
}

function littleGuysDance() {
	showLittleGuys(true);
	raDance.playAnim(FlxG.random.int(1, 4));
	sbDance.playAnim(FlxG.random.int(1, 4));
}

var thingy;
function glowRedArrow() {
	if (thingy != null) FlxTween.cancelTweensOf(thingy);
	thingy = FlxTween.num(3, 0.95, 0.15, {ease: FlxEase.cubeIn, onUpdate: (_) -> {
		dad.colorTransform.redMultiplier = thingy.value;
		dad.colorTransform.greenMultiplier = thingy.value;
		dad.colorTransform.blueMultiplier = thingy.value;
	}});
}
