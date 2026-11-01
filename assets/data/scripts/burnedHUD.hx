import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil;

var burn = Paths.font("vcr.ttf");

var burnedBar:FlxBar;
var burnedBarValue:Float;

public var dadHealth:String;
public var bfHealth:String;
public var fillDirection:String;

function postCreate() {
	for (h in [accuracyTxt, scoreTxt, healthBar, healthBarBG]){
		h.visible = false;
	}
	
	burnedBarBG = new FlxSprite(0, 0);
	burnedBarBG.loadGraphic(Paths.image('game/burnedHUD/healthBG'));
	burnedBarBG.antialiasing = false;
	burnedBarBG.updateHitbox();
	burnedBarBG.cameras = [camHUD];
	burnedBarBG.screenCenter();
	burnedBarBG.y = 465;
	
	
	burnedBar = new FlxBar(384, 633, FlxBarFillDirection.RIGHT_TO_LEFT, 511, 62, this, 'burnedBarValue', 0, 2, true);
	burnedBar.createImageBar
		(Paths.image("game/burnedHUD/health" + dadHealth), Paths.image("game/burnedHUD/health" + bfHealth), 0xFFFF0000, 0xFF00FF00);
	burnedBar.cameras = [camHUD];
	burnedBar.numDivisions = 800;

	insert(members.indexOf(iconP1, iconP2, missesTxt), burnedBarBG); 
	insert(members.indexOf(iconP1, iconP2, missesTxt), burnedBar);
	
	for (health in [burnedBar, burnedBarBG]) {
		health.scale.set(0.826, 0.826);
	}
}

function postUpdate(elapsed:Float) {
	burnedBarValue = lerp(burnedBarValue, health, 0.4);
	burnedBar.value = burnedBarValue;

	missesTxt.text = "Misses: " + misses + " | " + "Score: " + songScore;
	missesTxt.y = 696;
	
		burnedBarBG.flipY = camHUD.downscroll;
		burnedBar.flipY = camHUD.downscroll;
		
	doIconBop = false;
	for (icons in [iconP1, iconP2]){
		icons.scale.set(0.65, 0.65);
//		icons.y = 560;
	}
	iconP1.x = 812;
	iconP2.x = 322;
}

function onStrumCreation(note) note.sprite = "game/notes/bloody";
function onNoteCreation(note) note.noteSprite = "game/notes/bloody";
