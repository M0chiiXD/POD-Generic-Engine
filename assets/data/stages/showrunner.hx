public var crowdanim:Bool = false;
var crowdBounce:Int = 580;

function create() {
	piano.addAnim("idle", "piano idle", 12, true);
	violin.addAnim("idle", "violin idle", 12, true);
	drums.addAnim("idle", "drums idle", 12, true);
	crowd.addAnim("idle", "crowd idle", 12, false);
	crowd.addAnim("cheer", "crowd cheer", 12, false);

	piano.playAnim("idle");
	violin.playAnim("idle");
	drums.playAnim("idle");

	crowdanim = false;
}

function beatHit() {
	if (crowdanim) {
	crowd.playAnim("cheer");
	crowdBounce = 567; // haha 67
	} else {
	crowd.playAnim("idle");
	crowdBounce = 590;
	}

	FlxTween.tween(crowd, {y: crowdBounce}, 0.2, {ease: FlxEase.backOut, onComplete: (_) -> {
		FlxTween.tween(crowd, {y: 643}, 0.3, {ease: FlxEase.quadIn});
	}});
}



