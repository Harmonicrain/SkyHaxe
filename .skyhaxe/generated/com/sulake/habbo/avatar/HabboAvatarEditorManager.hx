package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDCoreWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.habbo.avatar._enum.AvatarRenderEvent;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.iid.IIDCoreLocalizationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import flash.events.Event;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboRoomUI;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;
    import com.sulake.habbo.avatar._enum.AvatarEditorEvent;
    import com.sulake.habbo.ui.IRoomDesktop;
    import com.sulake.iid.*;

     class HabboAvatarEditorManager extends Component implements IHabboAvatarEditor implements  ILinkEventTracker 
    {
        public static inline final SETUP_WITHOUT_INVENTORY:UInt = 1;
        public static inline final SETUP_WITHOUT_TOOLBAR:UInt = 2;
        public static inline final SETUP_WITHOUT_COMMUNICATION:UInt = 3;
        static final GENERIC:String = AvatarEditorFigureCategory.GENERIC;//"generic"

        var _windowManager:IHabboWindowManager;
        var _avatarRenderManager:IAvatarRenderManager;
        var _inventory:IHabboInventory;
        var _localization:IHabboLocalizationManager;
        var _communication:IHabboCommunicationManager;
        var _catalog:IHabboCatalog;
        var _sessionData:ISessionDataManager;
        var _roomUI:IRoomUI;
        var _handler:AvatarEditorMessageHandler;
        var _editors:Map;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._editors = new Map();
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDCoreWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_COMMUNICATION)) == 0)), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderManager = k;
            }, true, [{
                "type":AvatarRenderEvent.AVATAR_RENDER_READY,
                "callback":this.onAvatarRendererReady
            }]), new ComponentDependency(new IIDHabboInventory(), function (k:IHabboInventory)
            {
                _inventory = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_INVENTORY)) == 0), []), new ComponentDependency(new IIDCoreLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), null, true, [{
                "type":Event.COMPLETE,
                "callback":this.onConfigurationComplete
            }]), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_TOOLBAR)) == 0)), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionData = k;
            }), new ComponentDependency(new IIDHabboRoomUI(), function (k:IRoomUI)
            {
                _roomUI = k;
            }, false)]));
        }

        function onConfigurationComplete(k:Event)
        {
        }

        override function initComponent()
        {
            context.addLinkEventTracker(this);
            if (this._communication != null)
            {
                this._handler = new AvatarEditorMessageHandler(this, this._communication);
            }
        }

        override public function dispose()
        {
            var k:HabboAvatarEditor = null;
            if (this._editors != null)
            {
                final _iter_ = this._editors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                    k = null;
                }
                this._editors = null;
            }
            if (this._handler != null)
            {
                this._handler.dispose();
                this._handler = null;
            }
            super.dispose();
        }

        public function openEditor(k:UInt, _arg_2:_Str_5523, _arg_3:Array<ASAny>=null, _arg_4:Bool=false, _arg_5:String=null, _arg_6:String="generic"):IFrameWindow
        {
            var _local_7:HabboAvatarEditor = this._editors.getValue(k);
            if (_local_7 == null)
            {
                _local_7 = new HabboAvatarEditor(k, this);
                this._editors.add(k, _local_7);
            }
            return _local_7.openWindow(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function embedEditorToContext(k:UInt, _arg_2:IWindowContainer, _arg_3:_Str_5523=null, _arg_4:Array<ASAny>=null, _arg_5:Bool=false, _arg_6:Bool=false):Bool
        {
            var _local_7:HabboAvatarEditor = this._editors.getValue(k);
            if (_local_7 != null)
            {
                _local_7.dispose();
            }
            _local_7 = new HabboAvatarEditor(k, this, _arg_6);
            this._editors.add(k, _local_7);
            _local_7.embedToContext(_arg_2, _arg_3, _arg_4, _arg_5);
            return true;
        }

        public function loadAvatarInEditor(k:UInt, _arg_2:String, _arg_3:String, _arg_4:Int=0)
        {
            var _local_5= ASCompat.dynamicAs(this._editors.getValue(k) , HabboAvatarEditor);
            if (_local_5 != null)
            {
                return _local_5.loadAvatarInEditor(_arg_2, _arg_3, _arg_4);
            }
        }

        public function loadOwnAvatarInEditor(k:UInt)
        {
            var _local_2= ASCompat.dynamicAs(this._editors.getValue(k) , HabboAvatarEditor);
            if (_local_2 != null)
            {
                return _local_2.loadAvatarInEditor(this.sessionData.figure, this.sessionData.gender, this.sessionData.clubLevel);
            }
        }

        public function close(k:UInt)
        {
            if (this._editors == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._editors.getValue(k) , HabboAvatarEditor);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.figureData.avatarEffectType = this.inventory.getLastActivatedEffect();
            switch (k)
            {
                case AvatarEditorInstanceId.OWN_AVATAR_EDITOR:
                    _local_2.hide();
                    return;
                case AvatarEditorInstanceId.FURNITURE_AVATAR_EDITOR:
                    _local_2.hide();
                    _local_2.dispose();
                    this._editors.remove(k);
                    return;
                case AvatarEditorInstanceId.BOT_EDITOR:
                    return;
                default:
                    _local_2.dispose();
                    this._editors.remove(k);
            }
        }

        public function getEditor(k:UInt):HabboAvatarEditor
        {
            return ASCompat.dynamicAs(this._editors.getValue(k) , HabboAvatarEditor);
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        function onAvatarRendererReady(k:Event=null)
        {
            this.events.dispatchEvent(new Event(AvatarEditorEvent.AVATAR_EDITOR_READY));
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var handler(get,never):AvatarEditorMessageHandler;
public function  get_handler():AvatarEditorMessageHandler
        {
            return this._handler;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var sessionData(get,never):ISessionDataManager;
public function  get_sessionData():ISessionDataManager
        {
            return this._sessionData;
        }

        public var inventory(get,never):IHabboInventory;
public function  get_inventory():IHabboInventory
        {
            return this._inventory;
        }

        public var roomDesktop(get,never):IRoomDesktop;
public function  get_roomDesktop():IRoomDesktop
        {
            return this._roomUI.getDesktop("hard_coded_room_id");
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "avatareditor/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "open":
                    this.openEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR, null, null, true);
                    this.loadOwnAvatarInEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
                    return;
            }
        }
    }

