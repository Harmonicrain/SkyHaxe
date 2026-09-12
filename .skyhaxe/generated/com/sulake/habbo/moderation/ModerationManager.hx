package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.Component;
	import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.window.IHabboWindowManager;
	import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
	import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.friendbar.IHabboFriendBar;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorInitData;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
	import com.sulake.iid.IIDAvatarRenderManager;
	import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboFriendBar;
    import com.sulake.habbo.configuration._enum.HabboComponentFlags;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;

     class ModerationManager extends Component implements IHabboModeration 
    {
        var _windowManager:IHabboWindowManager;
        var _communicationManager:IHabboCommunicationManager;
        var _sessionDataManager:ISessionDataManager;
        var _navigator:IHabboNavigator;
        var _soundManager:IHabboSoundManager;
        var _tracking:IHabboTracking;
        var _friendBar:IHabboFriendBar;
		var _toolBar:IHabboToolbar;
		var _avatarRenderManager:IAvatarRenderManager;
        var _moderationMessageHandler:ModerationMessageHandler;
        var _issueManager:IssueManager;
        var _startPanelCtrl:StartPanelCtrl;
        var _windowTracker:WindowTracker;
        var _initMsg:ModeratorInitData;
        var _currentFlatId:Int = 0;
		var _moderationIconWidget:ModerationIconWidget;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._startPanelCtrl = new StartPanelCtrl(this);
            this._windowTracker = new WindowTracker();
			this._moderationIconWidget = new ModerationIconWidget(this);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:com.sulake.habbo.localization.IHabboLocalizationManager)
            {
                IssueCategoryNames._Str_25690(k);
            }), new ComponentDependency(new IIDHabboFriendBar(), function (k:IHabboFriendBar)
            {
                _friendBar = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolBar = k;
            }, false, 
			[{
                "type":HabboToolbarEvent.ICON_MODTOOL,
                "callback":this.onModToolIconClicked
            }]), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
			{
				_avatarRenderManager = k;
			})]));
        }

		function onModToolIconClicked(k:HabboToolbarEvent)
        {
			this._startPanelCtrl.toggleVisible();
        }
		
        override function initComponent()
        {
            if (HabboComponentFlags.isRoomViewerMode(ASCompat.toInt(flags)))
            {
                return;
            }
            this._moderationMessageHandler = new ModerationMessageHandler(this);
            this._issueManager = new IssueManager(this);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._startPanelCtrl != null)
            {
                this._startPanelCtrl.dispose();
                this._startPanelCtrl = null;
            }
            super.dispose();
        }

        public function userSelected(k:Int, _arg_2:String, figure:String=null, gender:String=null)
        {
            Logger.log([((("USER SELECTED: " + Std.string(k)) + ", ") + _arg_2)]);
            this._startPanelCtrl.userSelected(k, _arg_2, figure, gender);
        }
		
		public function setVisible(visible:Bool)
		{
			this._startPanelCtrl.setVisible(visible);
		}

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }
		
		public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
		{
			return this._avatarRenderManager;
		}

        public var issueManager(get,never):IssueManager;
public function  get_issueManager():IssueManager
        {
            return this._issueManager;
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._communicationManager.connection;
        }

        public var startPanel(get,never):StartPanelCtrl;
public function  get_startPanel():StartPanelCtrl
        {
            return this._startPanelCtrl;
        }

        
        public var initMsg(get,set):ModeratorInitData;
public function  get_initMsg():ModeratorInitData
        {
            return this._initMsg;
        }

        public var moderationMessageHandler(get,never):ModerationMessageHandler;
public function  get_moderationMessageHandler():ModerationMessageHandler
        {
            return this._moderationMessageHandler;
        }

        public var windowTracker(get,never):WindowTracker;
public function  get_windowTracker():WindowTracker
        {
            return this._windowTracker;
        }

        
        public var currentFlatId(get,set):Int;
public function  get_currentFlatId():Int
        {
            return this._currentFlatId;
        }

        public var soundManager(get,never):IHabboSoundManager;
public function  get_soundManager():IHabboSoundManager
        {
            return this._soundManager;
        }
public function  set_initMsg(k:ModeratorInitData):ModeratorInitData        {
            return this._initMsg = k;
        }
public function  set_currentFlatId(k:Int):Int        {
            return this._currentFlatId = k;
        }

        public var isModerator(get,never):Bool;
public function  get_isModerator():Bool
        {
            return this._sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR);
        }

        public function getXmlWindow(k:String, _arg_2:String="_xml", _arg_3:Int=1):IWindow
        {
            var _local_5:IAsset = null;
            var _local_6:XmlAsset = null;
            var _local_4:IWindow = null;
            try
            {
                _local_5 = assets.getAssetByName((k + _arg_2));
                _local_6 = cast(_local_5, XmlAsset);
                _local_4 = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_6.content), _arg_3);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return _local_4;
        }

        public function openHkPage(k:String, _arg_2:String)
        {
            var _local_3= getProperty(k);
            var _local_4= (_local_3 + _arg_2);
            var _local_5= "housekeeping";
            HabboWebTools.navigateToURL(_local_4, _local_5);
        }

        public function goToRoom(k:Int)
        {
            Logger.log([("MOD: GO TO ROOM: " + Std.string(k))]);
            this._navigator.goToPrivateRoom(k);
        }

        public function openThread(k:Int, _arg_2:Int)
        {
            context.createLinkEvent(((("groupforum/" + Std.string(k)) + "/") + Std.string(_arg_2)));
            Logger.log([((("MOD: OPEN THREAD: " + Std.string(k)) + ", ") + Std.string(_arg_2))]);
        }

        public function openThreadMessage(k:Int, _arg_2:Int, _arg_3:Int)
        {
            context.createLinkEvent(((((("groupforum/" + Std.string(k)) + "/") + Std.string(_arg_2)) + "/") + Std.string(_arg_3)));
            Logger.log([((((("MOD: OPEN THREAD MESSAGE: " + Std.string(k)) + ", ") + Std.string(_arg_2)) + ", ") + Std.string(_arg_3))]);
        }

        @:allow(com.sulake.habbo.moderation) function logEvent(k:String, _arg_2:String)
        {
            if (this._tracking != null)
            {
                this._tracking.trackEventLog("Moderation", _arg_2, k);
            }
        }

        @:allow(com.sulake.habbo.moderation) function trackGoogle(k:String, _arg_2:Int=-1)
        {
            if (this._tracking != null)
            {
                this._tracking.trackGoogle("moderationManager", k, _arg_2);
            }
        }

        public var cfhTopics(never,set):Vector<CallForHelpCategoryData>;
public function  set_cfhTopics(k:Vector<CallForHelpCategoryData>):Vector<CallForHelpCategoryData>        {
            this._issueManager.setCfhTopics(k);
return k;
        }
		
		public var moderationIcon(get,never):ModerationIconWidget;
public function  get_moderationIcon():ModerationIconWidget
		{
			return this._moderationIconWidget;
		}
    }

