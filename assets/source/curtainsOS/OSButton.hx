// made by m0chimyra <3
package curtainsOS.windows;

import curtainsOS.OSHoverable;
import flixel.math.FlxRect;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

class OSButton extends OSHoverable {
    public var text:String;
    public var label:FlxText;

    override public function new(_text:String, x:Float = 0, y:Float = 0, width:Float, height:Float, colorArray:Array, ?callback:Void->Void)
    {
        super(x, y, width, height, colorArray, callback);

        text = _text;

        label = new FlxText(0, 0, width, "");
        label.setPosition((width - (label.width + label.textWidth)) * 0.5, 3);
        updateLabel(text);
        instance.add(label);
    }

    public function updateLabel(_text) {
        label.text = _text;
        label.setFormat("fonts/marlett.ttf", 16, FlxColor.WHITE, "center");
    }
}
