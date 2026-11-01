import modchart.Manager;

var fm = 0;

var initX = [];
var initY = [];

function postCreate() {
	executeEvent({name: "Camera Movement", time: 0, params: [1, false]});
	for (h in [healthBar, healthBarBG, iconP1, iconP2]) h.visible = false;

	for(s in strumLines) {
		for(i in 0...4) {
			var note = s.members[i];
			initX[i] = note.x;
			initY[i] = note.y;
		}
	}
}

function stepHit(curStep) {
	switch (curStep) {
		case 128:
			fm = 1;
		case 384:
			fm = 8;
		case 512:
			fm = 1;
		case 656:
			fm = 2;
		case 784:
			fm = 3;
		case 912:
			fm = 5;
		case 1040:
			fm = 4;
		case 1152:
			fm = 0;
		case 1168:
			fm = 6;
		case 1288:
			fm = 0;
		case 1296:
			fm = 7;
	}
}

function postUpdate(elapsed) {
	for(s in strumLines) {
		switch (fm) {
			case 0:
				for(i in 0...4) {
					var note = s.members[i];
					note.x = initX[i];
					note.y = initY[i];
					note.angle = 0;
				}
			case 1:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = Math.sin(curBeatFloat + (i * 0.2)) * 20;
				}
			case 2:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = 0;
					note.x = initX[i];
					note.y = note.y - Math.sin(curBeatFloat + (i * 0.3));
				}
			case 3:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = 0;
					note.y = initY[i];
					note.x = note.x + Math.sin(curBeatFloat + (i * 0.08));
				}
			case 4:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = 0;
					note.y = initY[i];
					note.x = note.x + Math.sin(6);
				}
			case 5:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = 0;
					note.x = note.x + Math.sin(curBeatFloat + (i * 0.08));
					note.y = note.y - Math.sin(curBeatFloat + (i * 0.05));
				}
			case 6:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = Math.sin(curBeatFloat + (i * 0.2)) * 20;
					note.x = note.x + Math.sin(curBeatFloat + (i * 0.2));
				}
			case 7:
				for(i in 0...4) {
					var note = s.members[i];
					note.angle = Math.sin(curBeatFloat + (i * 0.2)) * 20;
					note.x = note.x + Math.sin(curBeatFloat + 0.25);
				}
			case 8:
				for(i in 0...4) {
					var n = s.members[i];
					n.y = n.y + Math.sin(curBeatFloat + 0.05);
					n.angle = flip ? -25 : 25;
				}
		}
	}
}

var flip:Bool = true;
function beatHit() flip = !flip;

