package com.sulake.habbo.friendbar.talent
;
    import com.sulake.habbo.friendbar.view.AbstractView;
    import com.sulake.habbo.friendbar.IHabboTalent;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.avatar.IHabboAvatarEditor;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboAvatarEditor;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrackLevel;
    import com.sulake.habbo.session.talent.TalentEnum;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;

     class HabboTalent extends AbstractView implements IHabboTalent implements  ILinkEventTracker 
    {
        var _talentTrack:TalentTrackController;
        var _talentLevelUp:TalentLevelUpController;
        var _talentPromo:TalentPromoCtrl;
        var _citizenshipPopup:CitizenshipPopupController;
        var _communicationManager:IHabboCommunicationManager;
        var _habboHelp:IHabboHelp;
        var _navigator:IHabboNavigator;
        var _toolbar:IHabboToolbar;
        var _avatarEditor:IHabboAvatarEditor;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        public var communicationManager(get,never):IHabboCommunicationManager;
public function  get_communicationManager():IHabboCommunicationManager
        {
            return this._communicationManager;
        }

        public var localizationManager(get,never):IHabboLocalizationManager;
public function  get_localizationManager():IHabboLocalizationManager
        {
            return _localizationManager;
        }

        public var _Str_20410(get,never):ISessionDataManager;
public function  get__Str_20410():ISessionDataManager
        {
            return _sessionDataManager;
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return _tracking;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return _windowManager;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._navigator;
        }

        public var _Str_24706(get,never):Bool;
public function  get__Str_24706():Bool
        {
            return getBoolean("talent.track.enabled");
        }

        public var _Str_9968(get,never):Bool;
public function  get__Str_9968():Bool
        {
            return getBoolean("talent.track.citizenship.enabled");
        }

        public var _Str_19829(get,never):Bool;
public function  get__Str_19829():Bool
        {
            return getBoolean("guide.help.new.user.tour.enabled");
        }

        public var newIdentity(get,never):Bool;
public function  get_newIdentity():Bool
        {
            return getInteger("new.identity", 0) > 0;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var avatarEditor(get,never):IHabboAvatarEditor;
public function  get_avatarEditor():IHabboAvatarEditor
        {
            return this._avatarEditor;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _habboHelp = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }), new ComponentDependency(new IIDHabboAvatarEditor(), function (k:IHabboAvatarEditor)
            {
                _avatarEditor = k;
            })]));
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._talentLevelUp != null)
                {
                    this._talentLevelUp.dispose();
                    this._talentLevelUp = null;
                }
                if (this._talentTrack != null)
                {
                    this._talentTrack.dispose();
                    this._talentTrack = null;
                }
                if (this._talentPromo != null)
                {
                    this._talentPromo.dispose();
                    this._talentPromo = null;
                }
                if (this._citizenshipPopup != null)
                {
                    this._citizenshipPopup.dispose();
                    this._citizenshipPopup = null;
                }
                context.removeLinkEventTracker(this);
                super.dispose();
            }
        }

        override function initComponent()
        {
            if (!this._Str_24706)
            {
                return;
            }
            this._talentTrack = new TalentTrackController(this);
            this._talentLevelUp = new TalentLevelUpController(this);
            this._talentPromo = new TalentPromoCtrl(this);
            if (this._Str_9968)
            {
                this._citizenshipPopup = new CitizenshipPopupController(this);
            }
            context.addLinkEventTracker(this);
            this._talentTrack.initialize();
            this._talentLevelUp.initialize();
            this._talentPromo.initialize();
        }

        public function send(k:IMessageComposer)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(k);
            }
        }

        public function getXmlWindow(name:String, layer:UInt=1):IWindow
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var window:IWindow = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                window = _windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content), layer);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboTalent", (((((("Failed to build window " + name) + "_xml, ") + asset) + ", ") + _windowManager) + "!"));
                throw e;
            }
 }            return window;
        }

        public function getModalXmlWindow(name:String):IModalDialog
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var dialog:IModalDialog = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                dialog = _windowManager.buildModalDialogFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboTalent", (((((("Failed to build window " + name) + "_xml, ") + asset) + ", ") + _windowManager) + "!"));
                throw e;
            }
 }            return dialog;
        }

        public function testLevelUp(k:String, _arg_2:TalentTrackLevel)
        {
            this._talentLevelUp.showWindow(k, _arg_2.level, _arg_2._Str_8893, _arg_2._Str_7068);
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "talent/";
        }

        public function linkReceived(k:String)
        {
            var _local_3:String = null;
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "open":
                    if (_local_2.length > 2)
                    {
                        _local_3 = _local_2[2];
                        switch (_local_3)
                        {
                            case TalentEnum.CITIZENSHIP:
                                _tracking.trackTalentTrackOpen(TalentEnum.CITIZENSHIP, "citizenshiplink");
                                this.send(new GetTalentTrackMessageComposer(TalentEnum.CITIZENSHIP));
                                
                            case TalentEnum.HELPER:
                                _tracking.trackTalentTrackOpen(TalentEnum.HELPER, "helperlink");
                                this.send(new GetTalentTrackMessageComposer(TalentEnum.HELPER));
                                
                        }
                    }
                    return;
                default:
                    Logger.log([("Catalog unknown link-type receive: " + _local_2[1])]);
            }
        }
    }

