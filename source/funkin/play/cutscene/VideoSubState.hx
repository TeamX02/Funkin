package funkin.play.cutscene;

// This was made to be used in those videos that don't necessarily change states (corrupted GF cutscene, Monika coding, etc...)
#if mobile
import extension.webview.WebView;
import flixel.FlxG;
import flixel.text.FlxText;
import funkin.ui.MusicBeatSubState;

using StringTools;

class VideoSubState extends MusicBeatSubState
{
  public static var androidPath:String = 'file:///android_asset/';

  var text:FlxText;
  var changecount = 0;

  public function new(source:String)
  {
    super();

    text = new FlxText(0, 0, 0, "Touch to continue", 48);
    text.screenCenter();
    text.alpha = 0;
    add(text);

    // FlxG.autoPause = false;

    WebView.onClose = onClose;
    WebView.onURLChanging = onURLChanging;
    source = source.replace('.mp4', '');
    WebView.open(androidPath + source + '.html', null, ['http://exitme(.*)']);
  }

  public override function update(dt:Float)
  {
    #if android
    if (FlxG.android.justReleased.BACK)
    {
      onClose();
    }
    #end

    super.update(dt);
  }

  function onClose()
  {
    text.alpha = 0;
    changecount = 0;
    // FlxG.autoPause = true;
    trace('aqui cabo!'); // ==11x3 Fnatic :skull:
    close();
  }

  function onURLChanging(url:String)
  {
    if (changecount == 2)
    {
      onClose();
    }
    else
    {
      changecount++;
      text.alpha = 1;
    }

    if (url == 'http://exitme(.*)')
    { // Not sure about this either, but it should make the video player close by itself.
      onClose(); // Dirty hack lol
    }

    trace("WebView is about to open: " + url);
  }
}
#end
