package;

//	Isso foi feito para ser usado naqueles vídeos que não nescessariamente trocam de state
//  por Matheus Silver
#if mobile
import extension.webview.WebView;
import flixel.FlxG;
import flixel.text.FlxText;

using StringTools;

class VideoSubState extends MusicBeatSubstate
{
  public static var androidPath:String = 'file:///android_asset/';

  var text:FlxText;
  var changecount = 0;

  public function new(source:String, ?cutsceneType:CutsceneType = STARTING)
  {
    super();

    text = new FlxText(0, 0, 0, "Touch to Continue", 48);
    text.screenCenter();
    text.alpha = 0;
    add(text);

    // FlxG.autoPause = false;

    WebView.onClose = onClose;
    WebView.onURLChanging = onURLChanging;

    WebView.open(androidPath + source + '.html', false, null, ['http://exitme(.*)']);
    PlayState.isSubState = true;
  }

  public override function update(dt:Float)
  {
    if (Utils.BSLTouchUtils.justTouched() || FlxG.android.justReleased.BACK) onClose();

    super.update(dt);
  }

  function onClose(cutsceneType:CutsceneType)
  { // not working
    text.alpha = 0;
    changecount = 0;
    // FlxG.autoPause = true;
    trace('aqui cabo!'); // ==11x3 Fnatic :skull:
    switch (cutsceneType)
    {
      case STARTING:
        PlayState.instance.startCountdown();
      case ENDING:
        PlayState.isInCutscene = false;
        PlayState.instance.endSong(true); // true = right goddamn now
      case CutsceneType.MIDSONG:
        // Do nothing.
        // throw "Not implemented!";
    }
    close();
  }

  function onURLChanging(url:String)
  {
    if (changecount == 2) onClose();
    else
      changecount++;
    text.alpha = 1;
    if (url == 'http://exitme(.*)') // Não tenho certeza sobre isso tambem, mas deve fazer com que o player de vídeo feche sozinho.
      onClose(); // drity hack lol
    trace("WebView is about to open: " + url);
  }
}

enum CutsceneType
{
  STARTING; // The default cutscene type. Starts the countdown after the video is done.
  MIDSONG; // Does nothing.
  ENDING; // Ends the song after the video is done.
}
#end
