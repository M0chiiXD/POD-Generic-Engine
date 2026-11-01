// made by m0chimyra <3
package curtainsOS.windows;

import curtainsOS.OSButton;
import curtainsOS.OSHoverable;
import curtainsOS.OSGroup;
import openfl.display.BlendMode;

import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxDestroyUtil;

import funkin.backend.scripting.DummyScript;
import funkin.backend.scripting.Script;
import funkin.backend.scripting.ScriptPack;

/*
 * This class is basically just a mini FlxSubState or so, I guess.
 */
class BasicWindow extends FlxSprite {
	public var instance:FlxSpriteGroup;
	public var windowContent:FlxSpriteGroup;

	public var x:Float = 215;
	public var y:Float = 105;

	public var width:Float = 870;
	public var height:Float = 490;

	public var windowWidth:Float = 860;
	public var windowHeight:Float = 455;

	//public static var cameras(default, null):Array;

	public var title:String;
	public var radius:Float = 6;
	public var borderColor:FlxColor = 0xFF6d9e9a;

	public var draggable:Bool = true;

	public var preCreated:Bool = true;
	public var created:Bool = false;
	public var postCreated:Bool = false;
	public var persistentUpdate:Bool = true;

	public var windowScripts:ScriptPack;
	public var scriptsAllowed:Bool = true;
	public var scriptName:String = null;

	public var barBounds:FlxSprite;
	public var closeWin:OSButton;
	public var maxWin:OSButton;
	public var instance:FlxState;
	public var maskBase:FlxSprite;
	public var windowBase:FlxSprite;
	public var windowTitle:FunkinText;

	public var allowSelect = false;

	private var parentGroup:FlxSpriteGroup;

	public function new(_scriptPath:String, grp:FlxSpriteGroup, ?_width:Float, ?_height:Float)
	{
		this.instance = instance;

		scriptName = (_scriptPath != null) ? _scriptPath : "gallerySubstates/test";

		if (_width != null) width = _width;
		if (_height != null) height = _height;

		parentGroup = grp;

		instance = new FlxSpriteGroup((FlxG.width - width) * 0.5, (FlxG.height - height) * 0.5);

		super(_scriptPath);

		if (title == null) title = "Test";

		barBounds = new FlxSprite().makeGraphic(width, height * 0.05, FlxColor.TRANSPARENT);
		maskShadow = new FlxSprite().makeGraphic(width, height, FlxColor.BLACK, true);
		maskBase = new FlxSprite().makeGraphic(width, height, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawRoundRectComplex(maskBase, 0, 0, width, height, radius, radius, radius, radius, borderColor, null, {smoothing: true});

		windowTitle = new FunkinText(25, 0, maskBase.width, "", 18).setFormat(Paths.font("Segoe/Segoe UI.ttf"), 20, FlxColor.WHITE, "left");

		instance.scrollFactor.set();

		var borderColorLight = borderColor + 0xFF002422;
		closeWin = new OSButton("\u003A", width - 45, 0, 40, 23, [0xFF8c4242, FlxColor.RED], close);
		maxWin = new OSButton("\u0020", width - 80, 0, 33, 23, [borderColor, borderColorLight], handleMaximize);

		maxWin.blend = closeWin.blend = maskBase.blend = BlendMode.OVERLAY;
		maskBase.alpha = 0.75;

		//instance.add(maskShadow);
		instance.add(maskBase);
		instance.add(windowTitle);
		instance.add(closeWin);
		instance.add(maxWin);

		windowContent = new FlxSpriteGroup(5, 30, width - 10, height - 35);
		instance.add(windowContent);

		instance.add(barBounds);

		for (windowh in instance.members) windowh.antialiasing = true;

		preCreated = true;
		if (preCreated) create();
	}

	public function create()
	{
		loadScript();
		call("create");
		created = true;

		if (!created) return;
		allowSelect = true;
		createPost();
	}

	public function createPost()
	{
		if (!created) return;

		call("postCreate");
		postCreated = true;
	}

	public function runAntialiasingCheck() {
		for (members in instance.members) if (!members.antialiasing) members.antialiasing = true;
		for (members in windowContent.members) if (!members.antialiasing) members.antialiasing = true;
		call("runAntialiasingCheck");
	}

	public function call(name:String, ?args:Array<Dynamic>, ?defaultVal:Dynamic):Dynamic
	{
		// calls the function on the assigned script
		if(windowScripts != null) return windowScripts.call(name, args);
		return defaultVal;
	}

	public function windowCenter(object:Dynamic, axes:String = XY)
	{
		object.setPosition(
			(width - object.width) * 0.5,
			(height - object.height) * 0.5
		);
	}

	// ripped directly from ModSubState, lol!!
	function loadScript()
	{
		var className = Type.getClassName(Type.getClass(this));
		if (windowScripts == null) (windowScripts = new ScriptPack(className)).setParent(this);
		if (scriptsAllowed) {
			if (windowScripts.scripts.length == 0) {
				var scriptName = this.scriptName != null ? this.scriptName : className.substr(className.lastIndexOf(".")+1);
				for (i in funkin.backend.assets.ModsFolder.getLoadedMods()) {
					var path = Paths.script('data/states/${scriptName}/LIB_$i');
					var script = Script.create(path);
					if (script is DummyScript) continue;
					script.remappedNames.set(script.fileName, '$i:${script.fileName}');
					windowScripts.add(script);
					script.load();
				}
			}
			#if EXPERMENTAL_SCRIPT_RELOADING
			else stateScripts.reload();
			#end
		}
	}

	var canPickAnother:Bool = true;
	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.overlaps(barBounds) && FlxG.mouse.pressed) if (topBelowMouse()) dragLogic();

		runAntialiasingCheck();

		windowTitle.text = title;

		var curIndex = parentGroup.members.indexOf(this);
		var topIndex = parentGroup.members.length - 1;
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(maskBase)) {
			if (!topBelowMouse() && !FlxG.mouse.overlaps(parentGroup.members[topIndex].maskBase) && !parentGroup.members[topIndex].maximized) {
				parentGroup.remove(this, true);
				parentGroup.add(this);
				onWindowFocus();
			}
		}

		FlxG.camera.zoom = 1;
		instance.setPosition(x, y);
		maskBase.scale.set(1, 1);

		if (maximized) {
			FlxG.camera.zoom = 1.475;
			maskBase.scale.set(1.15, 1.15);
			instance.setPosition((FlxG.width - width) * 0.5, (FlxG.height - height) * 0.5);
		}

		if (topBelowMouse()) { persistentUpdate = true; instance.alpha = 1; }
		else { persistentUpdate = false; instance.alpha = 0.5; }

		if (persistentUpdate) for (all in instance.members) all.update(elapsed);
		if (persistentUpdate) call("update", [elapsed]);
		super.update(elapsed);
		if (persistentUpdate) call("postUpdate", [elapsed]);
	}

	public function dragLogic() {
		var startMousePos:FlxPoint = new FlxPoint();
		var startComboOffset:FlxPoint = new FlxPoint();

		var dragX = (FlxG.mouse.deltaScreenX - startMousePos.x) + instance.x;
		var dragY = (FlxG.mouse.deltaScreenY- startMousePos.y) + instance.y;
		x = dragX;
		y = dragY;
	}

	private function topBelowMouse():Bool {
		var topMember = parentGroup.members.length - 1;
		if (parentGroup == null) return true;
		var myIndex = parentGroup.members.indexOf(this);
		if (topMember == myIndex) return true;
		else return false;
	}

	private function canPick() {
		var topMember = parentGroup.members.length;
		if (topMember = 0) return true;
		if (FlxG.mouse.overlaps(parentGroup.members[topMember].maskBase)) {
			trace("wtf");
			return false;
		} else return true;
	}

	//for compatibility with other scripts i guess
	public function lerp(v1:Float, v2:Float, ratio:Float, fpsSensitive:Bool = false) {
		if (fpsSensitive) return FlxMath.lerp(v1, v2, ratio);
		else return CoolUtil.fpsLerp(v1, v2, ratio);
	}

	public function add(object:FlxSprite) {
		windowContent.add(object);
	}

	public function insert(insert:Int, object:FlxSprite) {
		windowContent.insert(insert, object);
	}

	public override function draw():Void
	{
		instance.draw();
		windowContent.draw();
	}

	public function close() {
		call("close");
		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			parentGroup?.remove(this, true);
			destroy();
		});
	}

	private var maximized = false;
	public function handleMaximize() {
		if (!maximized) {
			savePosition(x, y);
			setPosition(0, 0);
			onMaximize();
			maxWin.updateLabel("\u0021");
			maximized = true;
		} else {
			loadSavedPosition();
			onUnMaximize();
			maxWin.updateLabel("\u0020");
			maximized = false;
		}

		allowSelect = false;
		new FlxTimer().start(0.15, function(tmr:FlxTimer){ allowSelect = true; });
	}

	private var savedX:Float;
	private var savedY:Float;
	public function savePosition(_x:Float, _y:Float) {
		savedX = _x;
		savedY = _y;
	}

	public function loadSavedPosition() {
		x = savedX;
		y = savedY;
		instance.setPosition(x, y);
	}

	override function destroy():Void {
		call("destroy");
		maximized = false;
		FlxG.camera.zoom = 1;
		FlxDestroyUtil.destroy(windowScripts);
		FlxDestroyUtil.destroy(instance);
		super.destroy();
	}

	public function onWindowFocus() {
		call("onWindowFocus");
	}

	public function onMaximize() {
		maskBase.alpha = 1;
		call("onMaximize");
	}

	public function onUnMaximize() {
		maskBase.alpha = 0.75;
		call("onUnMaximize");
	}

	public override function onWindowFocusLost() {
		call("onWindowFocusLost");
	}
}
