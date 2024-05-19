package mobile;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import funkin.ui.mainmenu.MainMenuState;
import flixel.FlxSprite;
import funkin.Paths;
import funkin.ui.AtlasText;
import flixel.input.mouse.FlxMouseEvent;

class CreditsMobileState extends FlxState { //is was ai generated ??????????????????????????????????????? :skull:
    override public function create():Void {
        super.create();

        var bg:FlxSprite = new FlxSprite(0, 0);
        bg.loadGraphic(Paths.image("menuBG"));
        add(bg);

        var title:FlxText = new FlxText(0, 20, FlxG.width, "Android Port Credits");
        title.setFormat(null, 32, FlxColor.WHITE, "center", OUTLINE, FlxColor.BLACK);
        add(title);

        var androidPorters:Array<{name:String, url:String}> = [
            {name: "Dxgamer", url: "https://www.youtube.com/@Dxgamer7405"},
            {name: "MarioMaster", url: "https://www.youtube.com/@MarioMaster39"},
            {name: "MaysLastPlay", url: "https://www.youtube.com/@MaysLastPlay"},
            {name: "Matheus Silver", url: "https://www.youtube.com/@MatheusSilver"},
            {name: "Mateusx02", url: "https://www.youtube.com/@mateusx02"},
            {name: "Pietro", url: "https://www.youtube.com/@pietro420"}
        ];

        for (i in 0...androidPorters.length) {     
            var texto:AtlasText = new AtlasText(0, 70 + i * 100, androidPorters[i].name, DEFAULT);
            texto.screenCenter(X);
            add(texto);

            FlxMouseEvent.add(texto, function onMouseDown(texto:AtlasText)
            {
                FlxG.openURL(androidPorters[i].url);
            }, null, null, null);


        } 

        var backButton:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height - 60, "Back", onBack);
        backButton.scale.set(2, 2);
        add(backButton);
    }

    private function onBack():Void {
        FlxG.switchState(new MainMenuState());
    }
}
