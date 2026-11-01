import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.shaders.BloomEffect;
import flixel.util.FlxSpriteUtil;

var glitch = new CustomShader("glitching");
glitch.SPEED = 0;
glitch.AMT = 0;
var blooming = new BloomEffect(120, 120, 8, 0.05, 0.45, 0.8);
var chiyo = new CustomShader("chiyo");
chiyo.pix = 8;

var stagey:FlxSprite = stage.getSprite("sprite_4");
var boxey:FlxSprite = stage.getSprite("sprite_5");
var persp = new CustomShader('perspective');

var templates:FlxSpriteGroup = new FlxSpriteGroup();

var time:Float = 0;
var iTime:Float = 0;
var itsjackTime:Bool = false;

function create()
{
    camHUD.addShader(glitch);
    camGame.addShader(glitch);
    camHUD.filters.push(blooming);
    camGame.filters.push(blooming);

    templates.camera = camHUD;

    bgThing = new FlxBackdrop(FlxGridOverlay.createGrid(100, 100, 200, 200, true, 0xFF65c8c8, 0xFF3434d0));
    bgThing.velocity.set(245, -95);
    insert(1, bgThing);

    eyes1 = new FlxBackdrop(Paths.image("stages/idkthissong/mindeye"));
    eyes1.velocity.set(305);
    eyes1.spacing.set(20, 400);
    eyes1.scale.set(0.18, 0.15);
    insert(3, eyes1);

    eye = new FlxSprite(1590, 400);
    eye.frames = Paths.getSparrowAtlas("stages/idkthissong/eyes");
    eye.animation.addByPrefix("eyes look", "eyes look", 8, false);
    eye.animation.addByPrefix("eyes open", "eyes open", 6, false);
    eye.animation.addByPrefix("eyes open end", "eyes open", 10, false);
    eye.setGraphicSize(680, 680);
    eye.visible = false;
    insert(3, eye);

    FlxTween.tween(eye, {x: eye.x - 12}, 1.6, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
    FlxTween.tween(eye, {y: eye.y - 15}, 1.3, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

    dad.shader = chiyo;
    dad.visible = false; eyes1.visible = false;
}

function postCreate() {
    executeEvent({name: "Screen Vignette", time: 0, params: [true , 3, 1, 1, "linear", "In"]});
    add(templates);

    foreBlocker = new FlxSprite(stagey.x, stagey.y).makeGraphic(stagey.width, stagey.height, FlxColor.TRANSPARENT);
    foreBlocker.camera = camGame;
    insert(members.indexOf(stagey) + 1, foreBlocker);
}

var bloomBop:Bool = false;
function beatHit() {
    if (bloomBop && (curBeat % 2 == 0)) blooming.strength = 1.85;
}

function update(elapsed:Float)
{
    iTime = time += elapsed;
    //chiyo.iTime = iTime;
    glitch.iTime = iTime;

    blooming.strength = lerp(blooming.strength, 1, 0.05);
}


function stepHit(step:Int) {
    switch (step) {
        case 256:
            dad.visible = true;
            FlxTween.num(8, 1, 4.35, {ease: FlxEase.quadIn}, (val:Float) -> { chiyo.pix = val; });
        case 760:
            FlxTween.num(0, 0.1, 3, {ease: FlxEase.quadIn}, (val:Float) -> { glitch.AMT = val; });
            FlxTween.num(0, 0.2, 3, {ease: FlxEase.quadIn}, (val:Float) -> { glitch.SPEED = val; });
            FlxTween.num(1, 12, 4, {ease: FlxEase.quadIn}, (val:Float) -> { chiyo.pix = val; });
        case 800:
            stage.getSprite("sprite_3").visible = false;
            cpu.visible = false;
            bloomBop = true;
            glitch.SPEED = 0;
            glitch.AMT = 0;
        case 820:
            eye.visible = true;
            eye.animation.play("eyes open");
            new FlxTimer().start(1, function(timer) {
                eye.animation.play("eyes look");
            });
        case 928:
            glitch.SPEED = 0.08;
            glitch.AMT = 0.0085;
            dad.visible = false;
            stagey.visible = false;
        case 1020:
            itsjackTime = true;
            templateTimer = new FlxTimer().start(2.8, function(timer)
            {
                if (!itsjackTime)
                    return;
                spawnTemplate();
            }, 0);
        case 1056:
            bf.shader = chiyo;
            FlxTween.num(12, 2, 0.5, {ease: FlxEase.quadIn}, (val:Float) -> { chiyo.pix = val; });
            glitch.SPEED = 0.1;
        case 1120:
            FlxTween.num(5, 3, 0.5, {ease: FlxEase.quadIn}, (val:Float) -> { chiyo.pix = val; });
        case 1184:
            glitch.AMT = 0.1;
            eye.visible = false;
            eyes1.visible = true;
        case 1306:
            FlxTween.tween(templates, {alpha: 0}, 1.23);
        case 1312:
            glitch.AMT = 0.0;
            glitch.SPEED = 0.0;
            chiyo.pix = 1;
            bloomBop = eyes1.visible = false;
            blooming.strength = 0;
            bgThing.visible = false;
            camGame.filters.remove(blooming);
            for (hp in [healthBar, healthBarBG, iconP1, iconP2]) hp?.visible = false;
            bf.colorTransform.color = 0xFFFFFFFF;
        case 1437:
            eye.colorTransform.color = 0xFFFFFFFF;
            eye.visible = true;
            eye.animation.play("eyes open end");
        case 1440:
            camGame.visible = false;
    }
}

function spawnTemplate()
{
    var template = new FlxSprite(1100, 310);
    template.frames = Paths.getSparrowAtlas("stages/idkthissong/template");
    template.animation.addByPrefix("template idle","template idle",2,true);
    template.animation.play("template idle");
    template.scale.set(0.3, 0.3);
    if (Options.downscroll) template.flipY = true;
    templates.add(template);
    FlxTween.tween(template, {x: template.x - 1500}, 16, {ease: FlxEase.linear,
        onComplete: function(_)
        {
            template.destroy();
        }
    });
}
