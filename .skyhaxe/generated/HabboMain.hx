 

    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import com.sulake.core.runtime.ICore;
    import flash.events.Event;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import com.sulake.core.Core;
    import flash.events.ProgressEvent;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.system.Capabilities;
    import com.sulake.core.runtime.ICoreErrorLogger;
    import flash.external.ExternalInterface;
    import com.sulake.core.runtime.IID;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.room.events.RoomEngineEvent;
import com.sulake.core.runtime.ICoreErrorLogger;

     class HabboMain extends Sprite 
    {
        public static final CORE_RATIO:Float = Habbo.CORE_RATIO;//0.6
        static inline final INIT_STEPS= 3;

        var _core:ICore;
        var _loadingScreen:IHabboLoadingScreen;
        var _totalSteps:Int = 3;
        var _loadedFiles:Int = 0;
        var _completedInitSteps:Int = 0;
        var roomEngineReady:Bool = false;
        var coreRunning:Bool = false;
        var _prepareCoreOnNextFrame:Bool = true;
        var _corePrepared:Bool = false;
        var _componentPreparationComplete:Bool = false;
        var _coreFilesComplete:Bool = false;
        var _coreInitializationStarted:Bool = false;
        var _startupErrorShown:Bool = false;
        var _disposed:Bool = false;
        var _coreDisplayContainer:DisplayObjectContainer;

        public function new(k:IHabboLoadingScreen, coreDisplayContainer:DisplayObjectContainer=null)
        {
            super();
            this._loadingScreen = k;
            this._coreDisplayContainer = coreDisplayContainer;
            addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            addEventListener(Event.EXIT_FRAME, (this.onExitFrame : ASAny));
            Logger.log([((getQualifiedClassName(Core) + " version: ") + Core.version)]);
        }

        function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            removeEventListener(ProgressEvent.PROGRESS, (this.onProgressEvent : ASAny));
            removeEventListener(Event.COMPLETE, (this.onCompleteEvent : ASAny));
            removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            removeEventListener(Event.EXIT_FRAME, (this.onExitFrame : ASAny));
            if (this._loadingScreen != null)
            {
                this._loadingScreen.dispose();
                this._loadingScreen = null;
            }
            if (this._core != null && !this._core.disposed && this._core.events != null)
            {
                this._core.events.removeEventListener(Component.COMPONENT_EVENT_RUNNING, this.onCoreRunning);
            }
            this._core = null;
            if (parent != null)
            {
                try
                {
                    parent.removeChild(this);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); {}
 }            }
        }

        public function disposeForReload()
        {
            this.dispose();
        }

        public function unloading()
        {
            try
            {
                if (((this._core != null) && (!this._core.disposed)))
                {
                    ErrorReportStorage.addDebugData("Unload", "Client unloading started");
                    this._core.events.dispatchEvent(new Event(Event.UNLOAD));
                }
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        function onAddedToStage(event:Event=null)
        {
            this._prepareCoreOnNextFrame = true;
        }

        function onExitFrame(k:Event=null)
        {
            if (this._prepareCoreOnNextFrame)
            {
                this._prepareCoreOnNextFrame = false;
                try
                {
                    this.prepareCore();
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                    Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CORE_FAIL);
                    Habbo.trackLoginStep(error.message);
                    Habbo.reportCrash(("Failed to prepare the core: " + error.message), Core.ERROR_CATEGORY_INITIALIZE_CORE, true, error);
                    Core.dispose();
                }
 }                return;
            }
            if ((this.coreRunning && this.roomEngineReady))
            {
                this.dispose();
            }
        }

        function prepareCore()
        {
var k:ICoreErrorLogger  = null, assetBase:String  = null, _local_2:com.sulake.core.utils.xml.XML  = null;            if (this._corePrepared)
            {
                return;
            }
            this._corePrepared = true;
			try
			{
k= HabboWebTools.isAirApplication ? new HabboAirCoreErrorReporter() : ((Capabilities.playerType != "StandAlone") ? new HabboCoreErrorReporter() : null);
            this._core = Core.instantiate((this._coreDisplayContainer != null) ? this._coreDisplayContainer : stage, Core.CORE_SETUP_FRAME_UPDATE_COMPLEX, k);
            this._core.prepareComponent(HabboTrackingLib);
            addEventListener(ProgressEvent.PROGRESS, (this.onProgressEvent : ASAny));
            addEventListener(Event.COMPLETE, (this.onCompleteEvent : ASAny));
assetBase= "";
            assetBase = HabboWebTools.getParameter("flash.client.url");
            if (assetBase == null) assetBase = "";
_local_2= new com.sulake.core.utils.xml.XML(("<config><asset-libraries><library url=\"" + assetBase + "hh_human_body.swf\"/><library url=\"" + assetBase + "hh_human_item.swf\"/></asset-libraries><service-libraries/><component-libraries/></config>"))
            ;
            this._core.readConfigDocument(_local_2, this);
            this._totalSteps = ASCompat.toInt((this._core.getNumberOfFilesPending() + this._core.getNumberOfFilesLoaded()) + INIT_STEPS);
            this.prepareComponentsCooperatively([
                CoreCommunicationFrameworkLib,
                HabboRoomObjectLogicLib,
                HabboRoomObjectVisualizationLib,
                RoomManagerLib,
                RoomSpriteRendererLib,
                HabboRoomSessionManagerLib,
                HabboAvatarRenderLib,
                HabboSessionDataManagerLib,
                HabboConfigurationCom,
                HabboLocalizationCom,
                HabboWindowManagerCom,
                HabboCommunicationCom,
                HabboCommunicationDemoCom,
                HabboNavigatorCom,
                HabboFriendListCom,
                HabboMessengerCom,
                HabboInventoryCom,
                HabboToolbarCom,
                HabboCatalogCom,
                HabboRoomEngineCom,
                HabboRoomUICom,
                HabboAvatarEditorCom,
                HabboNotificationsCom,
                HabboHelpCom,
                HabboAdManagerCom,
                HabboModerationCom,
                HabboUserDefinedRoomEventsCom,
                HabboSoundManagerFlash10Com,
                HabboQuestEngineCom,
                HabboFriendBarCom,
                HabboGroupsCom,
                HabboGamesCom,
                HabboFreeFlowChatCom,
                HabboNewNavigatorCom
            ], 0);
			}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 			{
				Habbo.trackLoginStep("Error in HabboMain (" + error.message + "): " + error.getStackTrace());
                if (HabboWebTools.isAirApplication)
                {
                    HabboWebTools.showAirError("Client startup error", "The client could not finish preparing required files.", error.message + " | " + error.getStackTrace());
                }
			}
 }        }

        /**
         * Browser scheduling boundary for the original component list.
         *
         * Flash spread this work across player frames while embedded library symbols became
         * available. In the HTML5 bundle every symbol is already addressable, so the converted
         * calls otherwise form one long JavaScript task. Preserve the exact order and graph, but
         * return to the event loop after a small time budget so rendering and socket callbacks can
         * run between batches.
         */
        function prepareComponentsCooperatively(components:Array<Class<Dynamic>>, index:Int)
        {
            try
            {
                var deadline = flash.Lib.getTimer() + 8;
                while ((index < components.length) && (flash.Lib.getTimer() < deadline))
                {
                    this._core.prepareComponent(components[index]);
                    index++;
                }
                if (index < components.length)
                {
                    var next = index;
                    ASCompat.setTimeout(function ()
                    {
                        this.prepareComponentsCooperatively(components, next);
                    }, 0);
                    return;
                }
                this.addInitializationProgressListeners();
                Habbo.trackLoginStep("addInitializationProgressListeners");
                this._componentPreparationComplete = true;
                this.initializeCoreWhenReady();
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                Habbo.trackLoginStep("Error while preparing component batch: " + error.message);
                Habbo.reportCrash(("Failed to prepare component batch: " + error.message), Core.ERROR_CATEGORY_PREPARE_COMPONENT, true, error);
                Core.dispose();
            }
 }        }

        function updateProgressBar()
        {
            var k = Math.NaN;
            if (this._loadingScreen != null)
            {
                k = (CORE_RATIO + (((this._completedInitSteps + this._loadedFiles) / this._totalSteps) * (1 - CORE_RATIO)));
                if (k > 1) k = 1;
                this._loadingScreen._Str_774(k);
            }
        }

        function onProgressEvent(k:ProgressEvent)
        {
            this._loadedFiles = ASCompat.toInt(this._core.getNumberOfFilesLoaded());
            this.updateProgressBar();
        }

        function onCompleteEvent(k:Event)
        {
            removeEventListener(ProgressEvent.PROGRESS, (this.onProgressEvent : ASAny));
            removeEventListener(Event.COMPLETE, (this.onCompleteEvent : ASAny));
            this._coreFilesComplete = true;
            this.initializeCoreWhenReady();
        }

        function initializeCoreWhenReady()
        {
            if (this._coreInitializationStarted || !this._coreFilesComplete || !this._componentPreparationComplete)
            {
                return;
            }
            this._coreInitializationStarted = true;
            this.initializeCore();
        }

        function initializeCore()
        {
			Habbo.trackLoginStep("Initializing Core!");
            try
            {
                this._core.initialize();
                if (ExternalInterface.available)
                {
                    ExternalInterface.addCallback("unloading", this.unloading);
                }
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
				Habbo.trackLoginStep(error.getStackTrace());
                Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CORE_FAIL);
                Core.crash(("Failed to initialize the core: " + error.message), Core.ERROR_CATEGORY_INITIALIZE_CORE, error);
            }
 }        }

        function simpleQueueInterface(k:IID, _arg_2:ASFunction)
        {
            var _local_3:ASObject = this._core.queueInterface(k, _arg_2);
            if (_local_3 != null)
            {
                _arg_2(k, _local_3);
            }
        }

        function addInitializationProgressListeners()
        {
            this.simpleQueueInterface(new IIDHabboLocalizationManager(), function (k:IID, _arg_2:Component)
            {
                _arg_2.events.addEventListener(Event.COMPLETE, onLocalizationComplete);
            });
            this.simpleQueueInterface(new IIDHabboConfigurationManager(), this.onConfigurationComplete);
            this.simpleQueueInterface(new IIDRoomEngine(), function (k:IID, _arg_2:Component)
            {
                var roomEngine= ASCompat.reinterpretAs(_arg_2 , IRoomEngine);
                _arg_2.events.addEventListener(RoomEngineEvent.ENGINE_INITIALIZED, onRoomEngineReady);
                if (((roomEngine != null) && roomEngine.isInitialized))
                {
                    onRoomEngineReady(null);
                }
            });
            this._core.events.addEventListener(Component.COMPONENT_EVENT_RUNNING, this.onCoreRunning);
        }

        function onLocalizationComplete(k:Event)
        {
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_LOCALIZATION_LOADED);
            this._completedInitSteps++;
            this.updateProgressBar();
        }

        function onConfigurationComplete(k:IID, _arg_2:Component)
        {
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CONFIG_LOADED);
            this._completedInitSteps++;
            this.updateProgressBar();
        }

        function onRoomEngineReady(k:Event)
        {
            if (this.roomEngineReady)
            {
                return;
            }
            this.roomEngineReady = true;
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_ROOM_READY);
            if (this._core.getInteger("spaweb", 0) == 1)
            {
                this.startSendingHeartBeat();
            }
        }

        function startSendingHeartBeat()
        {
            this.sendHeartBeat();
            ASCompat.setInterval(this.sendHeartBeat, 10000);
        }

        function startAirStartupWatchdog()
        {
            if (!HabboWebTools.isAirApplication)
            {
                return;
            }
            ASCompat.setTimeout(this.checkAirStartupProgress, 12000);
        }

        function checkAirStartupProgress()
        {
            var details:String = null;
            if (!HabboWebTools.isAirApplication || HabboWebTools.airLoginScreenVisible || this._startupErrorShown || this._disposed)
            {
                return;
            }
            if (this.coreRunning || this._completedInitSteps >= INIT_STEPS)
            {
                return;
            }
            this._startupErrorShown = true;
            details = "Client files URL: " + HabboWebTools.getParameter("flash.client.url");
            details += "\nVariables URL: " + HabboWebTools.getParameter("external.variables.txt");
            details += "\nTexts URL: " + HabboWebTools.getParameter("external.texts.txt");
            details += "\nProgress: loaded files " + Std.string(this._loadedFiles) + "/" + Std.string(this._totalSteps) + ", startup steps " + Std.string(this._completedInitSteps) + "/" + Std.string(INIT_STEPS);
            HabboWebTools.showAirError("Startup files are not loading", "NGHWin is waiting for files from your configured base.url, but startup has not finished. Make sure config.ini points to the correct web folder and that the Gordon files are reachable in a browser.", details);
        }

        function sendHeartBeat()
        {
            HabboWebTools.sendHeartBeat();
        }

        function onCoreRunning(k:Event)
        {
            this.coreRunning = true;
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CORE_RUNNING);
            this._completedInitSteps++;
            this.updateProgressBar();
        }
    }


private class HabboCoreErrorReporter implements ICoreErrorLogger 
{


    public function logError(k:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null)
    {
        Habbo.reportCrash(k, _arg_3, _arg_2, _arg_4);
    }
public function new(){}


}

private class HabboAirCoreErrorReporter implements ICoreErrorLogger
{
    public function logError(k:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null)
    {
        var url= this.extractQuotedUrl(k);
        var details= (url != null) ? ("Missing or unreachable file: " + url) : ("Technical error: " + k);
        if (com.sulake.habbo.utils.HabboWebTools.airLoginAttemptActive)
        {
            com.sulake.habbo.utils.HabboWebTools.airDebug("CORE ERROR DURING LOGIN: " + k);
            com.sulake.habbo.utils.HabboWebTools.showAirLoginError("Could not connect to the hotel server. Make sure the server is running and that connection.info.host / connection.info.port are correct.");
            return;
        }
        details += " | Category: " + Std.string(_arg_3);
        if (_arg_4 != null)
        {
            details += " | " + _arg_4.getStackTrace();
        }
        com.sulake.habbo.utils.HabboWebTools.showAirError("Required files could not load", "NGHWin could not download files it needs to start. Check config.ini, especially base.url and gordon.path, then confirm the shown file opens in your browser.", details);
    }

    function extractQuotedUrl(value:String):String
    {
        var start = 0;
        var end = 0;
        if (value == null)
        {
            return null;
        }
        start = value.indexOf("\"http");
        if (start < 0)
        {
            return null;
        }
        start++;
        end = value.indexOf("\"", start);
        if (end < 0)
        {
            return null;
        }
        return value.substring(start, end);
    }
public function new(){}
}
