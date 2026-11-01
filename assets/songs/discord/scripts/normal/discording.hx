importScript("data/scripts/squareResize");

function create() {
	VideoUtil.load(["trans"], [], camHUD);
}

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/discord_titlecard"));
	titlecard.x = 220;
    titlecard.y = -600;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 55:
			VideoUtil.playNext();
		case 62:
			FlxTween.tween(titlecard, { y: 100 }, 1.2, {ease: FlxEase.bounceOut});
		case 100:
			FlxTween.tween(titlecard, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
		case 728:
			FlxTween.tween(dad, {"scale.x": 2, "scale.y": 0.2}, 0.67, {ease: FlxEase.bounceOut});
			FlxTween.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		case 733:
			FlxTween.tween(dad.scale, {x: 1}, 0.5, {ease: FlxEase.bounceIn});
			FlxTween.tween(dad.scale, {y: 1}, 0.5, {ease: FlxEase.bounceOut});
		case 737: FlxTween.tween(camHUD, {alpha: 1}, 0.55, {ease: FlxEase.quadIn});
		case 753: FlxTween.tween(dad, {x: -120}, 0.2, {ease: FlxEase.quadOut});
		case 758: FlxTween.tween(dad, {x: -78}, 0.2, {ease: FlxEase.quadOut});
		case 761: FlxTween.tween(dad, {x: -120}, 0.2, {ease: FlxEase.quadOut});
		case 765: FlxTween.tween(dad, {x: -78}, 0.2, {ease: FlxEase.quadOut});
		case 769:
			FlxTween.tween(dad, {x: 2500}, 1.2, {ease: FlxEase.linear});
			FlxTween.angle(dad, 0, 1440, 1, {ease: FlxEase.quadIn});
			for (i in 0...cpuStrums.members.length) {
				var GPStrum = cpuStrums.members[i];
				FlxTween.tween(GPStrum, {x: GPStrum.x + 1000}, 1.2, {ease: FlxEase.linear});
			}
		case 810:
			for (i in 0...cpuStrums.members.length) {
				var GPStrum = cpuStrums.members[i];
				GPStrum.x -= 1000;
				GPStrum.y = GPStrum.y - 500;
				FlxTween.tween(GPStrum, {y: GPStrum.y + 500}, 0.5, {ease: FlxEase.quartOut});
			}
		case 832: dad.x = -110; dad.angle = 0;
		case 1472: FlxTween.angle(dad, 0, 1440, 1.4, {ease: FlxEase.quintIn});
		case 1520: dad.color = 0xFF1e40ff;
		case 1528: dad.color = FlxColor.WHITE;
	}
}
