package mobile;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import funkin.ui.mainmenu.MainMenuState;
import flixel.FlxSprite;
import funkin.Paths;

class CreditsMobileState extends FlxState {
    override public function create():Void {
        super.create();

        // Add the Background
        var bg:FlxSprite = new FlxSprite(0, 0);
        bg.loadGraphic(Paths.image("menuBG"));
        add(bg);

        // Create the title text
        var title:FlxText = new FlxText(0, 20, FlxG.width, "Credits");
        title.setFormat(null, 32, FlxColor.WHITE, "center");
        add(title);

        // Add credits buttons
        var androidPorters:Array<{name:String, url:String}> = [
            {name: "Dxgamer", url: "https://www.youtube.com/@Dxgamer7405"},
            {name: "MarioMaster", url: "https://www.youtube.com/@MarioMaster39"},
            {name: "MaysLastPlay", url: "https://www.youtube.com/@MaysLastPlay"},
            {name: "Matheus Silver", url: "https://www.youtube.com/@MatheusSilver"},
            {name: "Mateusx02", url: "https://www.youtube.com/@mateusx02"},
            {name: "Pietro", url: "https://www.youtube.com/@pietro420"}
        ];

        for (i in 0...androidPorters.length) {
            var porter = androidPorters[i];
            var porterButton:FlxButton = new FlxButton(FlxG.width / 2 - 60, 100 + i * 60, porter.name, function() { onPorterClick(porter.url); });
            porterButton.scale.set(2, 2);
            add(porterButton);
        }

        // Create a back button to return to the main menu
        var backButton:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height - 60, "Back", onBack);
        backButton.scale.set(2, 2);
        add(backButton);
    }

    private function onPorterClick(url:String):Void {
        FlxG.openURL(url);
    }

    private function onBack():Void {
        // Change to the main menu state (replace MainMenuState with your actual main menu state class)
        FlxG.switchState(new MainMenuState());
    }
}
