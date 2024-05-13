package funkin.ui;

import funkin.modding.IScriptedClass.IEventHandler;
import funkin.ui.mainmenu.MainMenuState;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import funkin.audio.FunkinSound;
import flixel.util.FlxSort;
import funkin.modding.PolymodHandler;
import funkin.modding.events.ScriptEvent;
import funkin.modding.module.ModuleHandler;
import funkin.util.SortUtil;
import funkin.input.Controls;
#if mobile
import mobile.MobileControls;
import mobile.flixel.FlxVirtualPad;
import flixel.FlxCamera;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end

/**
 * MusicBeatState actually represents the core utility FlxState of the game.
 * It includes functionality for event handling, as well as maintaining BPM-based update events.
 */
class MusicBeatState extends FlxTransitionableState implements IEventHandler
{
  var controls(get, never):Controls;

  inline function get_controls():Controls
    return PlayerSettings.player1.controls;

  #if mobile
  public var mobileControls:MobileControls;

  var virtualPad:FlxVirtualPad;
  var trackedInputsMobileControls:Array<FlxActionInput> = [];
  var trackedInputsVirtualPad:Array<FlxActionInput> = [];

  public function addVirtualPad(DPad:FlxDPadMode, Action:FlxActionMode)
  {
    if (virtualPad != null) removeVirtualPad();

    virtualPad = new FlxVirtualPad(DPad, Action);
    add(virtualPad);

    controls.setVirtualPadUI(virtualPad, DPad, Action);
    trackedInputsVirtualPad = controls.trackedInputsUI;
    controls.trackedInputsUI = [];
  }

  public function removeVirtualPad()
  {
    if (trackedInputsVirtualPad != []) controls.removeVirtualControlsInput(trackedInputsVirtualPad);

    if (virtualPad != null) remove(virtualPad);
  }

  public function addMobileControls(DefaultDrawTarget:Bool = true)
  {
    if (mobileControls != null) removeMobileControls();

    mobileControls = new MobileControls();

    switch (MobileControls.mode)
    {
      case 'Pad-Right' | 'Pad-Left' | 'Pad-Custom':
        controls.setVirtualPadNOTES(mobileControls.virtualPad, RIGHT_FULL, NONE);
      case 'Pad-Duo':
        controls.setVirtualPadNOTES(mobileControls.virtualPad, BOTH_FULL, NONE);
      case 'Hitbox':
        controls.setHitBox(mobileControls.hitbox);
      case 'Keyboard': // do nothing
    }

    trackedInputsMobileControls = controls.trackedInputsNOTES;
    controls.trackedInputsNOTES = [];

    var camControls:FlxCamera = new FlxCamera();
    FlxG.cameras.add(camControls, DefaultDrawTarget);
    camControls.bgColor.alpha = 0;

    mobileControls.cameras = [camControls];
    mobileControls.visible = false;
    add(mobileControls);
  }

  public function removeMobileControls()
  {
    if (trackedInputsMobileControls != []) controls.removeVirtualControlsInput(trackedInputsMobileControls);

    if (mobileControls != null) remove(mobileControls);
  }

  public function addVirtualPadCamera(DefaultDrawTarget:Bool = true)
  {
    if (virtualPad != null)
    {
      var camControls:FlxCamera = new FlxCamera();
      FlxG.cameras.add(camControls, DefaultDrawTarget);
      camControls.bgColor.alpha = 0;
      virtualPad.cameras = [camControls];
    }
  }
  #end

  public var leftWatermarkText:FlxText = null;
  public var rightWatermarkText:FlxText = null;

  public var conductorInUse(get, set):Conductor;

  var _conductorInUse:Null<Conductor>;

  function get_conductorInUse():Conductor
  {
    if (_conductorInUse == null) return Conductor.instance;
    return _conductorInUse;
  }

  function set_conductorInUse(value:Conductor):Conductor
  {
    return _conductorInUse = value;
  }

  public function new()
  {
    super();

    initCallbacks();
  }

  function initCallbacks()
  {
    subStateOpened.add(onOpenSubStateComplete);
    subStateClosed.add(onCloseSubStateComplete);
  }

  override function create()
  {
    super.create();

    createWatermarkText();

    Conductor.beatHit.add(this.beatHit);
    Conductor.stepHit.add(this.stepHit);
  }

  public override function destroy():Void
  {
    #if mobile
    if (trackedInputsMobileControls != []) controls.removeVirtualControlsInput(trackedInputsMobileControls);

    if (trackedInputsVirtualPad != []) controls.removeVirtualControlsInput(trackedInputsVirtualPad);
    #end

    super.destroy();

    #if mobile
    if (virtualPad != null)
    {
      virtualPad = FlxDestroyUtil.destroy(virtualPad);
      virtualPad = null;
    }

    if (mobileControls != null)
    {
      mobileControls = FlxDestroyUtil.destroy(mobileControls);
      mobileControls = null;
    }
    #end
    Conductor.beatHit.remove(this.beatHit);
    Conductor.stepHit.remove(this.stepHit);
  }

  function handleFunctionControls():Void
  {
    // Emergency exit button.
    if (FlxG.keys.justPressed.F4) FlxG.switchState(() -> new MainMenuState());

    #if desktop
    // This can now be used in EVERY STATE YAY!
    if (FlxG.keys.justPressed.F5) debug_refreshModules();
    #end
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    dispatchEvent(new UpdateScriptEvent(elapsed));
  }

  function createWatermarkText()
  {
    // Both have an xPos of 0, but a width equal to the full screen.
    // The rightWatermarkText is right aligned, which puts the text in the correct spot.
    leftWatermarkText = new FlxText(0, FlxG.height - 18, FlxG.width, '', 12);
    rightWatermarkText = new FlxText(0, FlxG.height - 18, FlxG.width, '', 12);

    // 100,000 should be good enough.
    leftWatermarkText.zIndex = 100000;
    rightWatermarkText.zIndex = 100000;
    leftWatermarkText.scrollFactor.set(0, 0);
    rightWatermarkText.scrollFactor.set(0, 0);
    leftWatermarkText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    rightWatermarkText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

    add(leftWatermarkText);
    add(rightWatermarkText);
  }

  public function dispatchEvent(event:ScriptEvent)
  {
    ModuleHandler.callEvent(event);
  }

  #if desktop
  function debug_refreshModules()
  {
    PolymodHandler.forceReloadAssets();

    this.destroy();

    // Create a new instance of the current state, so old data is cleared.
    FlxG.resetState();
  }
  #end

  public function stepHit():Bool
  {
    var event = new SongTimeScriptEvent(SONG_STEP_HIT, conductorInUse.currentBeat, conductorInUse.currentStep);

    dispatchEvent(event);

    if (event.eventCanceled) return false;

    return true;
  }

  public function beatHit():Bool
  {
    var event = new SongTimeScriptEvent(SONG_BEAT_HIT, conductorInUse.currentBeat, conductorInUse.currentStep);

    dispatchEvent(event);

    if (event.eventCanceled) return false;

    return true;
  }

  /**
   * Refreshes the state, by redoing the render order of all sprites.
   * It does this based on the `zIndex` of each prop.
   */
  public function refresh()
  {
    sort(SortUtil.byZIndex, FlxSort.ASCENDING);
  }

  override function startOutro(onComplete:() -> Void):Void
  {
    var event = new StateChangeScriptEvent(STATE_CHANGE_BEGIN, null, true);

    dispatchEvent(event);

    if (event.eventCanceled)
    {
      return;
    }
    else
    {
      FunkinSound.stopAllAudio();

      onComplete();
    }
  }

  public override function openSubState(targetSubState:FlxSubState):Void
  {
    var event = new SubStateScriptEvent(SUBSTATE_OPEN_BEGIN, targetSubState, true);

    dispatchEvent(event);

    if (event.eventCanceled) return;

    super.openSubState(targetSubState);
  }

  function onOpenSubStateComplete(targetState:FlxSubState):Void
  {
    dispatchEvent(new SubStateScriptEvent(SUBSTATE_OPEN_END, targetState, true));
  }

  public override function closeSubState():Void
  {
    var event = new SubStateScriptEvent(SUBSTATE_CLOSE_BEGIN, this.subState, true);

    dispatchEvent(event);

    if (event.eventCanceled) return;

    super.closeSubState();
  }

  function onCloseSubStateComplete(targetState:FlxSubState):Void
  {
    dispatchEvent(new SubStateScriptEvent(SUBSTATE_CLOSE_END, targetState, true));
  }
}
