package com.sulake.habbo.window
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.window.ICoreWindowManager;
    import com.sulake.core.window.IWindowFactory;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.window.IInputEventTracker;
    import com.sulake.core.window.IWidgetFactory;
    import flash.events.Event;
    import com.sulake.habbo.window._enum._Str_5209;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindowContext;
    import com.sulake.core.window.graphics.IWindowRenderer;
    import com.sulake.core.window.graphics.SkinContainer;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import com.sulake.core.window.tools.ProfilerOutput;
    import com.sulake.core.utils.profiler.ProfilerAgentTask;
    import com.sulake.habbo.window.theme.ThemeManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.window.utils.floorplaneditor.BCFloorPlanEditor;
    import com.sulake.habbo.window.utils.habbopedia._Str_7787;
    import com.sulake.habbo.window.handlers.HabbletLinkHandler;
    import com.sulake.habbo.window.utils.ElementPointerHandler;
    import com.sulake.core.utils.FontEnum;
    import com.sulake.core.window.components.HTMLTextController;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.window.utils.SkinParserUtil;
    import com.sulake.core.window.graphics.WindowRenderer;
    import flash.geom.Rectangle;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.runtime.IIDProfiler;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.android.AndroidUiPolicy;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.runtime.IProfiler;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.utils.DefaultAttStruct;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.habbo.window.utils.AlertDialog;
    import com.sulake.core.window.utils.INotify;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.window.utils.AlertDialogWithLink;
    import com.sulake.habbo.window.utils.IAlertDialogWithLink;
    import com.sulake.habbo.window.utils.ConfirmDialog;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.core.window.utils.MouseCursorControl;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.tracking.HabboErrorVariableEnum;
    import com.sulake.core.window.events.WindowEvent;
    import flash.system.Capabilities;
    import com.sulake.core.window.theme.IThemeManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.widgets.WidgetClasses;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.IWidget;
    import com.sulake.core.assets.IResourceManager;
    import com.sulake.habbo.window.utils.ModalDialog;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.habbo.window.utils.SimpleAlertDialog;
    import flash.text.StyleSheet;
    import com.sulake.core.window.events.*;
    import com.sulake.core.window.tools.*;

     class HabboWindowManagerComponent extends Component implements IHabboWindowManager implements  ICoreWindowManager implements  IWindowFactory implements  IUpdateReceiver implements  IInputEventTracker implements  IWidgetFactory 
    {
        static final _Str_16806:Event = new Event(_Str_5209.HABBO_WINDOW_TRACKING_EVENT_INPUT);
        static final _Str_18892:Event = new Event(_Str_5209.HABBO_WINDOW_TRACKING_EVENT_RENDER);
        static final _Str_18861:Event = new Event(_Str_5209.HABBO_WINDOW_TRACKING_EVENT_SLEEP);
        static inline final _Str_8995:UInt = 4;
        static inline final _Str_17369:UInt = 1;

        var _localization:IHabboLocalizationManager;
        var _windowContextArray:Array<ASAny>;
        var _windowContext:IWindowContext;
        var _windowRenderer:IWindowRenderer;
        var _skinContainer:SkinContainer;
        var _profiling:Bool = false;
        var _profilerOutput:ProfilerOutput;
        var _profilerAgentTaskUpdate:ProfilerAgentTask;
        var _profilerAgentTaskRedraw:ProfilerAgentTask;
        var _themeManager:ThemeManager;
        var _resourceManager:ResourceManager;
        var _hintManager:HintManager;
        var _avatarRenderer:IAvatarRenderManager;
        var _communication:IHabboCommunicationManager;
        var _sessionDataManager:ISessionDataManager;
        var _isInitialized:Bool = false;
        var _roomEngine:IRoomEngine;
        var _msSinceLastRoomEngineCheck:UInt = 0;
        var _bcfloorPlanEditor:BCFloorPlanEditor;
        var _habboPedia:_Str_7787;
        var _habbleLinkHandler:HabbletLinkHandler;
        var _elementPointerHandler:ElementPointerHandler;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            FontEnum.refresh();
            HTMLTextController._Str_16826 = "habboMain";
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }, false), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), function (k:com.sulake.core.runtime.IHabboConfigurationManager)
            {
            }, false, [{
                "type":Event.COMPLETE,
                "callback":this.onConfigurationComplete
            }]), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderer = k;
            }, false), new ComponentDependency(new IIDHabboCommunicationManager(), this._Str_23192, false), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }, false)]));
        }

        function _Str_23192(k:IHabboCommunicationManager)
        {
            this._communication = k;
        }

        function onConfigurationComplete(k:Event)
        {
            if (this._communication != null)
            {
                this._bcfloorPlanEditor = new BCFloorPlanEditor(this);
                this._elementPointerHandler = new ElementPointerHandler(this);
            }
        }

        override function initComponent()
        {
var k = 0, _local_2:IAsset  = null, _local_3:Rectangle = null, _local_5 = Math.NaN, _local_4:UInt = 0;			try
			{
            WindowContext.resetStaticState();
k= flash.Lib.getTimer();
_local_2= assets.getAssetByName("habbo_element_description_xml");
            if (_local_2 == null)
            {
                throw new ASError("Missing habbo_element_description_xml");
            }
            this._skinContainer = new SkinContainer();
            SkinParserUtil.parse(((_local_2.content : com.sulake.core.utils.xml.XML) ), assets, this._skinContainer);
            this._themeManager = new ThemeManager(this._skinContainer);
            this._resourceManager = new ResourceManager(this);
            this._hintManager = new HintManager(this);
            this._windowRenderer = new WindowRenderer(this._skinContainer);
            this._windowContextArray = ASCompat.allocArray(_Str_8995);
_local_3;
_local_5;
_local_4;
            while (_local_4 < _Str_8995)
            {
                _local_3 = AndroidUiPolicy.getWindowLayerRect(context.displayObjectContainer.stage.stageWidth, context.displayObjectContainer.stage.stageHeight);
                _local_5 = AndroidUiPolicy.getWindowLayerScale(_local_4);
                WindowContext.mobileViewport = (((AndroidUiPolicy.uiScale != 1) || (AndroidUiPolicy.safeInsetX > 0)) ? _local_3 : null);
                this._windowContextArray[ASCompat.toInt(_local_4)] = new WindowContext(("layer_" + Std.string(_local_4)), this._windowRenderer, this, this, this._resourceManager, this._localization, this, context.displayObjectContainer, _local_3, context.linkEventTrackers, _local_5);
                _local_4++;
            }
            this._windowContext = this._windowContextArray[ASCompat.toInt(_Str_17369)];
            this.addMouseEventTracker(this);
            registerUpdateReceiver(this, 0);
            queueInterface(new IIDProfiler(), this._Str_24384);
            k = (flash.Lib.getTimer() - k);
            Logger.log([(("initializing window framework took " + Std.string(k)) + "ms")]);
            this._isInitialized = true;
            this._habboPedia = new _Str_7787(this);
            this._habbleLinkHandler = new HabbletLinkHandler(this);
            context.addLinkEventTracker(this._habbleLinkHandler);
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(HabboWebTools.OPENLINK, context.createLinkEvent);
            }
			}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 			{
				Logger.log(["Error in initComponent; " + error.message + ", stacktrace: " + error.getStackTrace()]);
                if (HabboWebTools.isAirApplication)
                {
                    HabboWebTools.airDebug("Window manager init failed: " + error.message + " | " + error.getStackTrace());
                }
                throw error;
			}
 }        }

        function _Str_26104(k:WindowMouseEvent)
        {
            var _local_2:IWindow = null;
            Logger.log(["CRASH!"]);
            _local_2.background = true;
        }

        function _Str_24384(k:IID, _arg_2:IUnknown)
        {
            var _local_3= ASCompat.reinterpretAs(_arg_2 , IProfiler);
            if (_local_3 != null)
            {
                if (this._profilerOutput == null)
                {
                    this._profilerOutput = new ProfilerOutput(context, this, this._windowRenderer);
                }
                this._profilerOutput.profiler = _local_3;
				this._profilerOutput.visible = true;
                this._profilerAgentTaskUpdate = new ProfilerAgentTask("Update", "Event processing");
                _local_3.getProfilerAgentForReceiver(this).addSubTask(this._profilerAgentTaskUpdate);
                this._profilerAgentTaskRedraw = new ProfilerAgentTask("Redraw", "Window rasterizer");
                _local_3.getProfilerAgentForReceiver(this).addSubTask(this._profilerAgentTaskRedraw);
                this._profiling = true;
            }
        }

        function _Str_26100(k:IID, _arg_2:IUnknown)
        {
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._habbleLinkHandler != null)
                {
                    context.removeLinkEventTracker(this._habbleLinkHandler);
                    this._habbleLinkHandler.dispose();
                    this._habbleLinkHandler = null;
                }
                if (this._elementPointerHandler != null)
                {
                    this._elementPointerHandler.dispose();
                    this._elementPointerHandler = null;
                }
                removeUpdateReceiver(this);
                if (this._bcfloorPlanEditor != null)
                {
                    this._bcfloorPlanEditor.dispose();
                    this._bcfloorPlanEditor = null;
                }
                if (this._habboPedia != null)
                {
                    this._habboPedia.dispose();
                    this._habboPedia = null;
                }
                ModalDialog.resetStaticState();
                if (this._windowContextArray != null)
                {
                    while (this._windowContextArray.length > 0)
                    {
                        cast(this._windowContextArray.pop(), IDisposable).dispose();
                    }
                }
                this._windowContextArray = null;
                if (this._windowRenderer != null)
                {
                    this._windowRenderer.dispose();
                    this._windowRenderer = null;
                }
                if (this._skinContainer != null)
                {
                    this._skinContainer.dispose();
                    this._skinContainer = null;
                }
                if (this._resourceManager != null)
                {
                    this._resourceManager.dispose();
                    this._resourceManager = null;
                }
                if (this._hintManager != null)
                {
                    this._hintManager.dispose();
                    this._hintManager = null;
                }
                super.dispose();
            }
        }

        public function create(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:Rectangle, _arg_6:ASFunction=null, _arg_7:String="", _arg_8:UInt=0, _arg_9:Array<ASAny>=null, _arg_10:IWindow=null, _arg_11:Array<ASAny>=null, _arg_12:String=""):IWindow
        {
            return this._windowContext.create(k, _arg_7, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_10, _arg_8, _arg_11, _arg_12, _arg_9);
        }

        public function destroy(k:IWindow)
        {
            k.destroy();
        }

        public function buildFromXML(k:com.sulake.core.utils.xml.XML, _arg_2:UInt=1, _arg_3:Map=null):IWindow
        {
            var _local_4= this.getWindowContext(_arg_2).getWindowParser().parseAndConstruct(k, null, _arg_3);
            if (Std.is(_local_4 , IFrameWindow))
            {
                cast(_local_4, IFrameWindow)._Str_21008 = this.openHelpPage;
            }
            return _local_4;
        }

        public function windowToXMLString(k:IWindow):String
        {
            return this._windowContext.getWindowParser().windowToXMLString(k);
        }

        public function _Str_19128(k:UInt, _arg_2:UInt):com.sulake.core.utils.xml.XML
        {
            return this._skinContainer._Str_23436(k, _arg_2);
        }

        public function _Str_20294(k:UInt, _arg_2:UInt):DefaultAttStruct
        {
            return this._skinContainer._Str_21732(k, _arg_2);
        }

        public function getRendererByTypeAndStyle(k:UInt, _arg_2:UInt):ISkinRenderer
        {
            return (this._skinContainer != null) ? this._skinContainer._Str_18054(k, _arg_2) : null;
        }

        public function createWindow(k:String, _arg_2:String="", _arg_3:UInt=0, _arg_4:UInt=0, _arg_5:UInt=0, _arg_6:Rectangle=null, _arg_7:ASFunction=null, _arg_8:UInt=0, _arg_9:UInt=1, _arg_10:String=""):IWindow
        {
            return this._windowContextArray[ASCompat.toInt(_arg_9)].create(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, null, _arg_8, null, null, null);
        }

        public function removeWindow(k:String, _arg_2:UInt=1)
        {
            var _local_3:IDesktopWindow = this._windowContextArray[ASCompat.toInt(_arg_2)].getDesktopWindow();
            var _local_4= _local_3.getChildByName(k);
            if (_local_4 != null)
            {
                _local_4.destroy();
            }
        }

        public function getWindowByName(k:String, _arg_2:UInt=1):IWindow
        {
            return (this._windowContextArray[ASCompat.toInt(_arg_2)].getDesktopWindow() : ASAny).getChildByName(k);
        }

        public function getActiveWindow(k:UInt=1):IWindow
        {
            return (this._windowContextArray[ASCompat.toInt(k)].getDesktopWindow() : ASAny).getChildAt((this._windowContext.getDesktopWindow().numChildren - 1));
        }

        public function getWindowContext(k:UInt):IWindowContext
        {
            if (this._windowContextArray == null || this._windowContextArray[ASCompat.toInt(k)] == null)
            {
                throw new ASError("Window context " + Std.string(k) + " is not initialized");
            }
            return this._windowContextArray[ASCompat.toInt(k)];
        }

        public function getDesktop(k:UInt):IDesktopWindow
        {
            var _local_2:IWindowContext = this._windowContextArray[ASCompat.toInt(k)];
            return (_local_2 != null) ? _local_2.getDesktopWindow() : null;
        }

        public function notify(k:String, _arg_2:String, _arg_3:ASFunction, _arg_4:UInt=0):INotify
        {
            var alertAsset= assets.getAssetByName("habbo_window_alert_xml");
            if (alertAsset == null)
            {
                throw new ASError("Failed to initialize alert dialog; missing asset!");
            }
            var _local_6= ((alertAsset.content : com.sulake.core.utils.xml.XML) );
            return new AlertDialog(this, _local_6, k, _arg_2, _arg_4, _arg_3, false);
        }

        public function alert(k:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IAlertDialog
        {
            var alertAsset= assets.getAssetByName("habbo_window_alert_xml");
            if (alertAsset == null)
            {
                throw new ASError("Failed to initialize alert dialog; missing asset!");
            }
            var _local_6= ((alertAsset.content : com.sulake.core.utils.xml.XML) );
            return new AlertDialog(this, _local_6, k, _arg_2, _arg_3, _arg_4, false);
        }

        public function alertWithModal(k:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IAlertDialog
        {
            var alertAsset= assets.getAssetByName("habbo_window_alert_xml");
            if (alertAsset == null)
            {
                throw new ASError("Failed to initialize alert dialog; missing asset!");
            }
            var _local_6= ((alertAsset.content : com.sulake.core.utils.xml.XML) );
            return new AlertDialog(this, _local_6, k, _arg_2, _arg_3, _arg_4, true);
        }

        public function alertWithLink(k:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:UInt, _arg_6:ASFunction):IAlertDialogWithLink
        {
            var alertAsset= assets.getAssetByName("habbo_window_alert_link_xml");
            if (alertAsset == null)
            {
                throw new ASError("Failed to initialize alert dialog; missing asset!");
            }
            var _local_8= ((alertAsset.content : com.sulake.core.utils.xml.XML) );
            return new AlertDialogWithLink(this, _local_8, k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function confirm(k:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IConfirmDialog
        {
            var confirmAsset= assets.getAssetByName("habbo_window_confirm_xml");
            if (confirmAsset == null)
            {
                throw new ASError("Failed to initialize aleret dialog; missing asset!");
            }
            var _local_6= ((confirmAsset.content : com.sulake.core.utils.xml.XML) );
            return new ConfirmDialog(this, _local_6, k, _arg_2, _arg_3, _arg_4, false);
        }

        public function confirmWithModal(k:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IConfirmDialog
        {
            var confirmAsset= assets.getAssetByName("habbo_window_confirm_xml");
            if (confirmAsset == null)
            {
                throw new ASError("Failed to initialize aleret dialog; missing asset!");
            }
            var _local_6= ((confirmAsset.content : com.sulake.core.utils.xml.XML) );
            return new ConfirmDialog(this, _local_6, k, _arg_2, _arg_3, _arg_4, true);
        }

        public function registerLocalizationParameter(k:String, _arg_2:String, _arg_3:String, _arg_4:String="%")
        {
            this._localization.registerParameter(k, _arg_2, _arg_3, _arg_4);
        }

        public function update(k:UInt)
        {
			var _local_2 = 0;
			if (this._profiling)
			{
				this._profilerAgentTaskUpdate.start();
			};
			if (WindowContext.inputEventQueue.length > 0)
			{
				events.dispatchEvent(_Str_16806);
				_local_2 = ASCompat.toInt(_Str_8995 - 1);
				while (_local_2 >= 0)
				{
					this._windowContextArray[_local_2].update(k);
					_local_2--;
				};
			};
			if (this._profiling)
			{
				this._profilerAgentTaskUpdate.stop();
			};
			if (this._profiling)
			{
				this._profilerAgentTaskRedraw.start();
			};
			events.dispatchEvent(_Str_18892);
			_local_2 = 0;
			while ((_local_2 : UInt) < _Str_8995)
			{
				this._windowContextArray[_local_2].render(k);
				_local_2++;
			};
			if (this._profiling)
			{
				this._profilerAgentTaskRedraw.stop();
			};
			if (WindowContext.inputEventQueue.length > 0)
			{
				WindowContext.inputEventQueue.flush();
			};
			MouseCursorControl.change();
			events.dispatchEvent(_Str_18861);
        }

        override public function purge()
        {
            super.purge();
            if (this._windowRenderer != null)
            {
                this._windowRenderer.purge();
            }
        }

        public function addMouseEventTracker(k:IInputEventTracker)
        {
            var _local_2:IWindowContext = null;
            final _iter_ = this._windowContextArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.addMouseEventTracker(k);
            }
        }

        public function removeMouseEventTracker(k:IInputEventTracker)
        {
            var _local_2:IWindowContext = null;
            final _iter_ = this._windowContextArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.removeMouseEventTracker(k);
            }
        }

        public function eventReceived(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2 != null)
            {
                if (k.type == WindowMouseEvent.CLICK)
                {
                    ErrorReportStorage.setParameter(HabboErrorVariableEnum.CLICK_TIME, Std.string(Date.now().getTime()));
                    ErrorReportStorage.setParameter(HabboErrorVariableEnum.CLICK_TARGET, ((_arg_2.name + ": ") + _arg_2.toString()));
                }
                else
                {
                    if (k.type == WindowMouseEvent.UP)
                    {
                        ErrorReportStorage.setParameter(HabboErrorVariableEnum.MOUSE_UP_TIME, Std.string(Date.now().getTime()));
                        ErrorReportStorage.setParameter(HabboErrorVariableEnum.MOUSE_UP_TARGET, ((_arg_2.name + ": ") + _arg_2.toString()));
                    }
                }
            }
        }

        function _Str_25877()
        {
            Logger.log([((((("type: " + Capabilities.playerType) + " debugger: ") + Std.string(Capabilities.isDebugger)) + " version: ") + Capabilities.version)]);
        }

        public function findWindowByName(k:String):IWindow
        {
            var _local_2:IWindow = null;
            var _local_3:IWindowContext = null;
            final _iter_ = this._windowContextArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_2 = _local_3.findWindowByName(k);
                if (_local_2 != null)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function findWindowByTag(k:String):IWindow
        {
            var _local_2:IWindow = null;
            var _local_3:IWindowContext = null;
            final _iter_ = this._windowContextArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_2 = _local_3.findWindowByTag(k);
                if (_local_2 != null)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function groupWindowsWithTag(k:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            var _local_5:IWindowContext = null;
            var _local_4:UInt = 0;
            final _iter_ = this._windowContextArray; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_4 = (_local_4 + _local_5.groupChildrenWithTag(k, _arg_2, _arg_3));
            }
            return _local_4;
        }

        public function getThemeManager():IThemeManager
        {
            return this._themeManager;
        }

        public function createUnseenItemCounter():IWindowContainer
        {
            var k= assets.getAssetByName("unseen_item_counter_xml") ;
            var _local_2= ((k.content : com.sulake.core.utils.xml.XML) );
            return Std.downcast(this.buildFromXML(_local_2) , IWindowContainer);
        }

        public function createWidget(k:String, _arg_2:IWidgetWindow):IWidget
        {
            var _local_3:Class<Dynamic> = WidgetClasses._Str_3059[k];
            if (_local_3 != null)
            {
                return Type.createInstance(_local_3, [_arg_2, this]);
            }
            throw new ASError((("Unknown widget type " + k) + "! You might need to update Glaze to be able to work on this layout."));
        }

        public var _Str_1458(get,never):IAvatarRenderManager;
public function  get__Str_1458():IAvatarRenderManager
        {
            return this._avatarRenderer;
        }

        public var resourceManager(get,never):IResourceManager;
public function  get_resourceManager():IResourceManager
        {
            return this._resourceManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public function buildModalDialogFromXML(k:com.sulake.core.utils.xml.XML):IModalDialog
        {
            return new ModalDialog(this, k);
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public function simpleAlert(k:String, _arg_2:String, _arg_3:String, _arg_4:String=null, _arg_5:String=null, _arg_6:Map=null, _arg_7:String=null, _arg_8:ASFunction=null, _arg_9:ASFunction=null)
        {
            new SimpleAlertDialog(this, k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
        }

        public function registerHintWindow(k:String, _arg_2:IWindow, _arg_3:Int=1)
        {
            this._hintManager.registerWindow(k, _arg_2, _arg_3);
        }

        public function unregisterHintWindow(k:String)
        {
            this._hintManager.unregisterWindow(k);
        }

        public function showHint(k:String, _arg_2:Rectangle=null)
        {
            this._hintManager.showHint(k, _arg_2);
        }

        public function hideHint()
        {
            this._hintManager.hideHint();
        }

        public function hideMatchingHint(k:String)
        {
            this._hintManager.hideMatchingHint(k);
        }

        public function displayFloorPlanEditor()
        {
            if (this._bcfloorPlanEditor == null)
            {
                this._bcfloorPlanEditor = new BCFloorPlanEditor(this);
            }
            if (this._bcfloorPlanEditor != null)
            {
                this._bcfloorPlanEditor.visible = true;
            }
        }

        public function openHelpPage(k:String)
        {
            if (this._habboPedia != null)
            {
                this._habboPedia.openPage(k);
            }
        }

        public var habboPagesStyleSheet(get,never):StyleSheet;
public function  get_habboPagesStyleSheet():StyleSheet
        {
            return _Str_7787.styleSheet;
        }
    }

