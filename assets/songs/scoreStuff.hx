import flixel.util.FlxStringUtil;
import funkin.game.PlayState;
import funkin.game.PlayState.ComboRating;
import haxe.ds.ObjectMap;
import funkin.options.Options;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreChange;
import Date;

PauseSubState.script = 'data/scripts/podpausemenu';
GameOverSubstate.script = 'data/scripts/gameover/gameOver';

public static var justPlayed:Bool;

allowGitaroo = false;

var zeroLengthSongs:Array<String> = ["burned", "carnivorous", "greeeducation"];

function create(){
	introLength = 1; 
	for (item in zeroLengthSongs) {
		if (PlayState.SONG.meta.name.toLowerCase() == item) { 
			introLength = 0; 
		}
	}
}

function onCountdown(event:CountdownEvent) event.cancel();
function onStrumCreation(_) _.__doAnimation = false;

function postCreate() {
	justPlayed = true;

	var phant = Paths.font("PhantomMuff.ttf");
	missesTxt.font = phant;
	missesTxt.y += 6;
	missesTxt.size = 17.5;
	
	for (h in [accuracyTxt, scoreTxt]) h.destroy();
	
	healthBarBG.loadGraphic(Paths.image('game/healthBarOverlay'));
	healthBarBG.offset.x = 21;
	healthBarBG.offset.y = 11;
	healthBar.scale.set(1, 1.1);
	remove(healthBarBG, true);
	insert(members.indexOf(healthBar) + 1, healthBarBG);
	healthBar.createGradientBar([FlxColor.WHITE, dad.iconColor], [bf.iconColor, FlxColor.WHITE], 1, 200);
	
	doIconBop = false;

	if (downscroll){
		healthBarBG?.offset.y = -9;
		missesTxt.y = 610;
	}
	
	healthBar.numDivisions = 1000;
	
	FlxG.camera.zoom = defaultCamZoom;
}

var scoreLerp;
function postUpdate() {	
	scoreLerp = FlxMath.lerp(scoreLerp, PlayState.instance.songScore, 0.1);
	var acc = FlxMath.roundDecimal(Math.max(accuracy, 0) * 100, 2);
	missesTxt.text = "Score: " + Std.parseInt(scoreLerp) + " | " + "Misses: " + misses + " | " + "Accuracy: " + acc + "% - " + getSongRank(acc);
}

function beatHit() {
	for (icons in [iconP1, iconP2]) {
		FlxTween.cancelTweensOf(icons);
		icons.scale.set(1.25, 1.25);
		FlxTween.tween(icons, {"scale.x": 1, "scale.y": 1}, 0.12, {ease: FlxEase.circOut});
	}
	
	var turnIt:Int = 20;
	if (curBeat % 2 == 0){
		turnIt = -turnIt;
	}
	
	iconP1.angle = turnIt;
	iconP2.angle = -turnIt;
	FlxTween.tween(iconP1, {angle: 0}, 0.2, {ease: FlxEase.circOut});
	FlxTween.tween(iconP2, {angle: 0}, 0.2, {ease: FlxEase.circOut});
}

function getSongRank(acc:Int):String {
	if (acc >= 99) {
		return "Packing!";
	} else if (acc >= 90) {
		return "Green!";
	} else if (acc >= 80) {
		return "Blue";
	} else if (acc >= 70) {
		return "Nice";
	} else if (acc >= 69) {
        return "ayoooo sus?";
	} else if (acc >= 60) {
        return "Sixty";
	} else if (acc >= 50) {
        return "mid";
	} else if (acc >= 40) {
        return "red";
	} else if (acc >= 30) {
        return "hot";
	} else if (acc >= 20) {
        return "getting closer to your DEMISE";
	} else if (acc >= 10) {
        return "uh oh!";
	} else if (acc >= 5) {
        return "sinking sinking drowning drowning";
	} else {
		return "[N/A]";
	}
}

public static var lastMenu:String;
function onSongEnd(event){	
	// idk guys
	if (!PlayState.chartingMode || !PlayState.isStoryMode) {
		event.cancel();
		
		if (validScore) {
			#if !switch
			FunkinSave.setSongHighscore(PlayState.SONG.meta.name, PlayState.difficulty, PlayState.variation, {
			score: songScore,
			misses: misses,
			accuracy: accuracy,
			hits: hits,
			date: Date.now().toString()
			}, PlayState.getSongChanges());
			#end
			
			if (lastMenu == "Freeplay") FlxG.switchState(new FreeplayState());
			else if (lastMenu == "Gallery") FlxG.switchState(new ModState("PODGallery")); 
		}
	} 
}
