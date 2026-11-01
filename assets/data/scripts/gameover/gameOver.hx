import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;

var gameover = new FlxVideo();

static var burnedvar:String;

lossSFX = null;

var garbulous:Array = ["fun-and-silly", "whos-that"];

var path = "deaths/" + PlayState.SONG.meta.name;

function create(e) {
	for (cur in garbulous) {
		if (PlayState.SONG.meta.name.toLowerCase() == cur) {
		//	e.cancel();

		//	connorGameOver();
		}
	}

	if (Assets.exists(Paths.video(path))) {
		if (gameover.load(Paths.video(path))) gameover.play();
		e.cancel();
		FlxG.addChildBelowMouse(gameover);
	} else if (PlayState.SONG.meta.name == "burned") {
		e.cancel();
		if (gameover.load(Paths.video(path + "-" + burnedvar))) gameover.play();
			gameover.play();
			FlxG.addChildBelowMouse(gameover);
	}
}

function connorGameOver() {
	//ill do it laterrrrrrrrrhhhh
}

function update() {
	if (controls.BACK || controls.ACCEPT) {
		FlxG.switchState(new PlayState());
	} 
}

function destroy(){
	gameover.dispose();
	FlxG.removeChild(gameover);
}
