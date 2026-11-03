import flixel.text.FlxText;
//import flixel.effects.particles.FlxTypedEmitter;
//import flixel.effects.particles.FlxParticle;

importScript("data/scripts/squareResize");

var blackOverlay;
var scratch = Paths.font("HelveticaNeueMedium.otf");
var scoreT:FlxText;
var guitar:FlxSprite;
var donutter:FlxTypedEmitter<FlxParticle>;
var donuts:Bool = false;
var titlecard;

function create() {
	scoretxt = new FlxText();
	scoretxt.color = FlxColor.WHITE;
	scoretxt.font = scratch;
	scoretxt.size = 24;
	scoretxt.x = 12;
	scoretxt.y = 680;
	scoretxt.cameras = [camHUD];
	
	misstxt = new FlxText();
	misstxt.color = FlxColor.WHITE;
	misstxt.font = scratch;
	misstxt.size = 24;
	misstxt.x = camHUD.width / 2 - 12;
	misstxt.y = 680;
	misstxt.autoSize = false;
	misstxt.fieldWidth = 360;
	misstxt.alignment = "right";
	misstxt.cameras = [camHUD];
	
	blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1024, 768, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    insert(0, blackOverlay);
	
	guitar = new FlxSprite(120, 1000);
	guitar.loadGraphic(Paths.image("stages/avery/guitar-electric1"));
	guitar.cameras = [camGame];
	guitar.angle = 80;
	guitar.scale.set(1.3, 1.3);
	insert(members.indexOf(dad, bf) + 2, guitar);
	guitar.visible = false;
}

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/mydog_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 1;
    titlecard.y = 150;
    titlecard.x = -1000;
	titlecard.scale.set(0.9, 0.9);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);

	missesTxt.visible = false;
	
	remove(iconP1);
	remove(iconP2);
	add(iconP1);
	add(iconP2);
	add(scoretxt);
	add(misstxt);
	
	doIconBop = false;
	
	switchChar(0);
}

function update(elapsed:Float){
		scoretxt.text = "Score: " + songScore;
		misstxt.text = "Misses: " + misses;
}

function onNoteCreation(note) note.noteSprite = "game/notes/averyNotes";

function onStrumCreation(note) note.sprite = "game/notes/averyNotes";

function onNoteHit(e) e.showSplash = false;

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 5, {
        onComplete: function(twn:FlxTween) {
        }
    });
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 504:
			blackOverlay.alpha = 1;
		case 524:
			switchChar(1);
			blackOverlay.alpha = 0.5;
		case 1052:
			switchChar(0);
			blackOverlay.alpha = 0;
		case 1324:
			switchChar(1);
			blackOverlay.alpha = 0.5;
		case 1436:
			blackOverlay.alpha = 0.7;
		case 1564:
			blackOverlay.alpha = 0.5;
			guitar.visible = true;
			FlxTween.tween(guitar, {y: 300}, 2, {ease: FlxEase.quadOut});
		case 1692:
			FlxTween.tween(guitar, {alpha: 0}, 2, {ease: FlxEase.quadOut});
		case 1836:
			blackOverlay.alpha = 1;
			guitar.destroy();
		case 128:
			FlxTween.tween(titlecard, {x: 200}, 1, {ease: FlxEase.linear});
		case 168:
			FlxTween.tween(titlecard, {x: 900, y: -1200}, 1, {ease: FlxEase.linear});
	}
}

function switchChar(struh:Int) {
	if (struh == 0){
		iconP2.setIcon("avery");
	} else if (struh == 1){
		iconP2.setIcon("averyevil");
	}
}