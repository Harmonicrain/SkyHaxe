package com.sulake.habbo.freeflowchat
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.moderation.IHabboModeration;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.freeflowchat.data.ChatEventHandler;
    import com.sulake.habbo.freeflowchat.data.RoomSessionEventHandler;
    import com.sulake.habbo.freeflowchat.history.ChatHistoryBuffer;
    import com.sulake.habbo.freeflowchat.viewer.simulation.ChatFlowStage;
    import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryScrollView;
    import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryTray;
    import com.sulake.habbo.freeflowchat.viewer.ChatFlowViewer;
    import com.sulake.habbo.freeflowchat.viewer.ChatBubbleFactory;
    import com.sulake.habbo.communication.messages.incoming.room.chat.RoomChatSettingsMessageEvent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.viewer.visualization.ManualNineSliceSprite;
    import com.sulake.habbo.freeflowchat.viewer._enum.ChatMarkup;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.ChatStyle;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboModeration;
    import com.sulake.iid.IIDHabboRoomUI;
    import com.sulake.iid.IIDHabboGameManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.habbo.communication.messages.incoming.perk.PerkAllowancesEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.GetGuestRoomResultEvent;
	import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomChatSettings;
    import com.sulake.habbo.communication.messages.incoming.preferences.AccountPreferencesEvent;
    import flash.geom.Point;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import com.sulake.habbo.configuration._enum.HabboComponentFlags;
    import com.sulake.room.utils.IVector3d;
    import flash.display.DisplayObject;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomObjectMessage;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import flash.events.MouseEvent;
    import com.sulake.habbo.freeflowchat.style.IChatStyleLibrary;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetChatPreferencesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetChatStylePreferenceComposer;

     class HabboFreeFlowChat extends Component implements IHabboFreeFlowChat 
    {
        var _avatarRenderManager:IAvatarRenderManager;
        var _roomSessionManager:IRoomSessionManager;
        var _roomEngine:IRoomEngine;
        var _navigator:IHabboNavigator;
        var _moderation:IHabboModeration;
        var _roomUI:IRoomUI;
        var _gameManager:IHabboGameManager;
        var _localizationManager:IHabboLocalizationManager;
        var _toolbar:IHabboToolbar;
        var _communication:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _sessionDataManager:ISessionDataManager;
        var _chatEventHandler:ChatEventHandler;
        var _roomEventHandler:RoomSessionEventHandler;
        var _chatHistoryBuffer:ChatHistoryBuffer;
        var _chatFlowStage:ChatFlowStage;
        var _chatHistoryScrollView:ChatHistoryScrollView;
        var _chatHistoryPulldown:ChatHistoryTray;
        var _chatFlowViewer:ChatFlowViewer;
        var _chatViewController:ChatViewController;
        var _chatBubbleFactory:ChatBubbleFactory;
        var _perkAllowed:Bool = false;
        var _isInRoom:Bool = false;
        var _roomChatSettings:RoomChatSettings;
        var _freeFlowDisabled:Bool = false;
        var _preferedChatStyle:Int = 1;
        var _chatFontSizeMode:Int = 0;
        var _roomChangeRecordedInHistory:Bool = false;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
        }

        public static function getTimeStampNow():String
        {
            var k= Date.now();
            var _local_2= k.getHours();
            var _local_3= k.getMinutes();
            var _local_4= k.getSeconds();
            var _local_5= ((_local_2 < 10) ? ("0" + Std.string(_local_2)) : Std.string(_local_2));
            _local_5 = ((_local_5 + ":") + ((_local_3 < 10) ? ("0" + Std.string(_local_3)) : Std.string(_local_3)));
            _local_5 = ((_local_5 + ":") + ((_local_4 < 10) ? ("0" + Std.string(_local_4)) : Std.string(_local_4)));
            return _local_5;
        }

        public static function create9SliceSprite(k:Rectangle, _arg_2:BitmapData):Sprite
        {
            return new Scale9BitmapSprite(k, _arg_2);
        }

        public static function createPixelPerfect9SliceSprite(k:Rectangle, _arg_2:BitmapData):Sprite
        {
            return new ManualNineSliceSprite(k, _arg_2);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }, false), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderManager = k;
            }, false), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }, false), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }, false), new ComponentDependency(new IIDHabboModeration(), function (k:IHabboModeration)
            {
                _moderation = k;
            }, false), new ComponentDependency(new IIDHabboRoomUI(), function (k:IRoomUI)
            {
                _roomUI = k;
            }, false), new ComponentDependency(new IIDHabboGameManager(), function (k:IHabboGameManager)
            {
                _gameManager = k;
            }, false), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }, false), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }, false), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }, false)]));
        }

        override function initComponent()
        {
            this._communication.addHabboConnectionMessageEvent(new PerkAllowancesEvent(this.onPerkAllowances));
            this._communication.addHabboConnectionMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            this._communication.addHabboConnectionMessageEvent(new GetGuestRoomResultEvent(this.onGuestRoomData));
            this._communication.addHabboConnectionMessageEvent(new RoomChatSettingsMessageEvent(this.onRoomChatSettings));
            this._communication.addHabboConnectionMessageEvent(new AccountPreferencesEvent(this.onAccountPreferences));
        }

        function onPerkAllowances(k:PerkAllowancesEvent)
        {
            var _local_2= this._perkAllowed;
            this._perkAllowed = true;
            if (((!_local_2) && this._perkAllowed))
            {
                this._chatBubbleFactory = new ChatBubbleFactory(this);
                if (!this.isDisabledInPreferences)
                {
                    this._chatEventHandler = new ChatEventHandler(this);
                    this._roomEventHandler = new RoomSessionEventHandler(this);
                    this._chatHistoryBuffer = new ChatHistoryBuffer(this);
                }
                if (this._isInRoom)
                {
                    this.roomEntered();
                }
            }
            else
            {
                if ((_local_2 && (!this._perkAllowed)))
                {
                    if (this._chatBubbleFactory != null)
                    {
                        this._chatBubbleFactory.dispose();
                        this._chatBubbleFactory = null;
                    }
                    if (this._chatEventHandler != null)
                    {
                        this._chatEventHandler.dispose();
                        this._chatEventHandler = null;
                    }
                    if (this._roomEventHandler != null)
                    {
                        this._roomEventHandler.dispose();
                        this._roomEventHandler = null;
                    }
                    if (this._chatHistoryBuffer != null)
                    {
                        this._chatHistoryBuffer.dispose();
                        this._chatHistoryBuffer = null;
                    }
                    this.roomLeft();
                }
            }
        }

        function onGuestRoomData(k:GetGuestRoomResultEvent)
        {
            if (((this._chatHistoryBuffer != null) && (!this._roomChangeRecordedInHistory)))
            {
                this._chatHistoryBuffer._Str_24587(k.getParser().data);
            }
            this._roomChangeRecordedInHistory = true;
            this._roomChatSettings = k.getParser().chatSettings;
            if (this._chatFlowStage != null)
            {
                this._chatFlowStage._Str_18127();
            }
        }

        function onRoomEnter(k:RoomEntryInfoMessageEvent)
        {
            this._roomChangeRecordedInHistory = false;
            this.clear();
        }

        function onRoomChatSettings(k:RoomChatSettingsMessageEvent)
        {
            this._roomChatSettings = k.getParser().chatSettings;
            if ((this._isInRoom && (this._chatFlowStage != null)))
            {
                this._chatFlowStage._Str_18127();
            }
        }

        function onAccountPreferences(k:AccountPreferencesEvent)
        {
            this._freeFlowDisabled = k.getParser().freeFlowChatDisabled;
            this._preferedChatStyle = k.getParser().preferedChatStyle;
            this._chatFontSizeMode = this.clampChatFontSizeMode(k.getParser().chatSizePreference);
        }

        public function getRoomChangeBitmap():BitmapData
        {
            return cast(assets.getAssetByName("room_change").content, BitmapData);
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        public var gameManager(get,never):IHabboGameManager;
public function  get_gameManager():IHabboGameManager
        {
            return this._gameManager;
        }

        public var localizations(get,never):IHabboLocalizationManager;
public function  get_localizations():IHabboLocalizationManager
        {
            return this._localizationManager;
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

        public function roomEntered()
        {
            this._isInRoom = true;
            if ((((this._perkAllowed && (this._chatBubbleFactory != null)) && (this._chatEventHandler != null)) && (this._roomEventHandler != null)))
            {
                this._chatFlowStage = new ChatFlowStage(this);
                this._chatFlowViewer = new ChatFlowViewer(this, this._chatFlowStage);
                this._chatHistoryScrollView = new ChatHistoryScrollView(this, this._chatHistoryBuffer);
                this._chatHistoryPulldown = new ChatHistoryTray(this, this._chatHistoryScrollView);
                this._chatViewController = new ChatViewController(this, this._chatFlowViewer, this._chatHistoryPulldown);
            }
        }

        public function roomLeft()
        {
            if (this._chatHistoryPulldown != null)
            {
                this._chatHistoryPulldown.dispose();
                this._chatHistoryPulldown = null;
            }
            if (this._chatHistoryScrollView != null)
            {
                this._chatHistoryScrollView.dispose();
                this._chatHistoryPulldown = null;
            }
            if (this._chatFlowViewer != null)
            {
                this._chatFlowViewer.dispose();
                this._chatFlowViewer = null;
            }
            if (this._chatFlowStage != null)
            {
                this._chatFlowStage.dispose();
                this._chatFlowStage = null;
            }
            if (this._chatViewController != null)
            {
                this._chatViewController.dispose();
                this._chatViewController = null;
            }
            this._isInRoom = false;
        }

        public function insertChat(chatItem:ChatItem)
        {
            var insertPosition:Point = null;
            var chatBubble:PooledChatBubble = null;
            if (((((!this._perkAllowed) || (!(this._chatHistoryBuffer != null))) || (!(this._chatFlowStage != null))) || this.isDisabledInPreferences))
            {
                return;
            }
            this.fixHtml(chatItem, cast(this.chatStyleLibrary.getStyle(chatItem.style), ChatStyle));
            this._chatHistoryBuffer.insertChat(chatItem);
            try
            {
                chatBubble = this._chatBubbleFactory._Str_22521(chatItem);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                if (e.errorID == 2015)
                {
                    return;
                }
                throw e;
            }
 }            insertPosition = this._chatFlowStage._Str_12872(chatBubble);
            this._chatFlowViewer._Str_12872(chatBubble, insertPosition);
        }

        public function getScreenPointFromRoomLocation(k:Int, _arg_2:IVector3d):Point
        {
            var _local_8:Point = null;
            var _local_9:Point = null;
            if ((((this._roomEngine == null) || (this._chatFlowViewer == null)) || (this._chatFlowViewer._Str_5128.stage == null)))
            {
                return new Point(0, 0);
            }
            var _local_3= (HabboComponentFlags.isRoomViewerMode(ASCompat.toInt(flags)) ? 1 : -1);
            var _local_4= this.roomEngine.getRoomCanvasGeometry(k, _local_3);
            var _local_5= this.roomEngine.getRoomCanvasScale(k);
            var _local_10= this.chatViewRect;
            var _local_6= ((_local_10.x + (_local_10.width / 2)) * _local_5);
            var _local_7= ((_local_10.y + (_local_10.height / 2)) * _local_5);
            if (((!(_local_4 == null)) && (!(_arg_2 == null))))
            {
                _local_8 = _local_4.getScreenPoint(_arg_2);
                if (_local_8 != null)
                {
                    _local_6 = (_local_6 + (_local_8.x * _local_5));
                    _local_7 = (_local_7 + (_local_8.y * _local_5));
                    _local_9 = this.roomEngine.getRoomCanvasScreenOffset(k);
                    if (_local_9 != null)
                    {
                        _local_6 = (_local_6 + _local_9.x);
                        _local_7 = (_local_7 + _local_9.y);
                    }
                }
            }
            return new Point(_local_6, _local_7);
        }

        /**
         * Bounds of Free Flow Chat in its own (logical) window coordinate space.
         *
         * On Android the window desktop is scaled after layout. Stage dimensions are therefore
         * physical device pixels and must not be mixed with room-canvas coordinates. The room view
         * is a sibling of the chat wrapper and supplies the exact logical bounds used by both.
         */
        public var chatViewRect(get,never):Rectangle;
public function  get_chatViewRect():Rectangle
        {
            var viewRect:Rectangle = null;
            var root:DisplayObject = null;
            var origin:Point = null;
            var edge:Point = null;
            if (this._roomUI != null)
            {
                viewRect = this._roomUI.getRoomViewRect();
                if (viewRect != null && viewRect.width > 0 && viewRect.height > 0)
                {
                    return viewRect;
                }
            }
            root = this.displayObject;
            if (root != null && root.stage != null)
            {
                origin = root.globalToLocal(new Point(0, 0));
                edge = root.globalToLocal(new Point(root.stage.stageWidth, root.stage.stageHeight));
                return new Rectangle(0, 0, Math.abs(edge.x - origin.x), Math.abs(edge.y - origin.y));
            }
            return new Rectangle(0, 0, 800, 600);
        }

        public var chatViewWidth(get,never):Int;
public function  get_chatViewWidth():Int
        {
            return Std.int(Math.fround(this.chatViewRect.width));
        }

        public var chatViewHeight(get,never):Int;
public function  get_chatViewHeight():Int
        {
            return Std.int(Math.fround(this.chatViewRect.height));
        }

        public var chatFlowViewer(get,never):ChatFlowViewer;
public function  get_chatFlowViewer():ChatFlowViewer
        {
            return this._chatFlowViewer;
        }

        public var chatBubbleFactory(get,never):ChatBubbleFactory;
public function  get_chatBubbleFactory():ChatBubbleFactory
        {
            return this._chatBubbleFactory;
        }

        public function createChatStylePreviewBitmap(styleId:Int, userName:String, figure:String, sampleText:String):BitmapData
        {
            if (this._chatBubbleFactory == null)
            {
                return null;
            }
            return this._chatBubbleFactory.createStylePreviewBitmap(styleId, userName, figure, sampleText);
        }

        public var chatHistoryScrollView(get,never):ChatHistoryScrollView;
public function  get_chatHistoryScrollView():ChatHistoryScrollView
        {
            return this._chatHistoryScrollView;
        }

        public var displayObject(get,never):DisplayObject;
public function  get_displayObject():DisplayObject
        {
            if (this._chatViewController != null)
            {
                return this._chatViewController._Str_5128;
            }
            return null;
        }

        public function disableRoomMouseEventsLeftOfX(k:Int)
        {
            // _roomEngine is an optional injected dependency. NGHWin's F5 reload disposes the
            // RoomEngine component first, so the DI framework nulls _roomEngine back out while this
            // chat component is still alive; a window resize in that window otherwise reaches here
            // (via the chat tray) and throws #1009. Guarded like the _roomEngine == null check above.
            if (this._roomEngine == null)
            {
                return;
            }
            this._roomEngine.mouseEventsDisabledLeftToX = k;
        }

        public function selectAvatarWithChatItem(k:ChatItem)
        {
            this.selectAvatar(k.roomId, k.userId);
        }

        public function selectAvatar(k:Int, _arg_2:Int)
        {
            var _local_5:RoomUserData = null;
            var _local_6:RoomUserData = null;
            if (this._roomUI == null)
            {
                return;
            }
            var _local_3= this._roomUI.getDesktop("hard_coded_room_id");
            _local_3.processWidgetMessage(new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_GET_OBJECT_INFO, _arg_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER));
            this.roomEngine.selectAvatar(k, _arg_2);
            var _local_4= this._roomSessionManager.getSession(k);
            if (_local_4 != null)
            {
                _local_5 = _local_4.userDataManager.getUserDataByIndex(_arg_2);
                if (_local_5 != null)
                {
                    _local_6 = this._roomSessionManager.getSession(k).userDataManager.getUserDataByIndex(_arg_2);
                    if (((_local_6 != null) && (this._moderation != null)))
                    {
                        this._moderation.userSelected(_local_5.id, _local_6.name);
                    }
                }
            }
        }

        public var roomChatSettings(get,never):RoomChatSettings;
public function  get_roomChatSettings():RoomChatSettings
        {
            return this._roomChatSettings;
        }

        public var roomChatBorderLimited(get,never):Bool;
public function  get_roomChatBorderLimited():Bool
        {
            if (this._roomChatSettings != null)
            {
                return this._roomChatSettings.mode == RoomChatSettings.CHAT_MODE_LINE_BY_LINE;
            }
            return false;
        }

        public function clickHasToPropagate(k:MouseEvent):Bool
        {
            return (this._roomUI != null) ? this._roomUI.mouseEventPositionHasContextMenu(k) : false;
        }

        public var chatStyleLibrary(get,never):IChatStyleLibrary;
public function  get_chatStyleLibrary():IChatStyleLibrary
        {
            return (this._chatBubbleFactory != null) ? this._chatBubbleFactory.chatStyleLibrary : null;
        }

        
        public var isDisabledInPreferences(get,set):Bool;
public function  get_isDisabledInPreferences():Bool
        {
            return this._freeFlowDisabled;
        }
public function  set_isDisabledInPreferences(k:Bool):Bool        {
            this._freeFlowDisabled = k;
            this._communication.connection.send(new SetChatPreferencesMessageComposer(this._freeFlowDisabled));
return k;
        }

        
        public var preferedChatStyle(get,set):Int;
public function  get_preferedChatStyle():Int
        {
            return this._preferedChatStyle;
        }
public function  set_preferedChatStyle(k:Int):Int        {
            this._preferedChatStyle = k;
            this._communication.connection.send(new SetChatStylePreferenceComposer(this._preferedChatStyle, this._chatFontSizeMode));
return k;
        }

        
        public var chatFontSizeMode(get,set):Int;
public function  get_chatFontSizeMode():Int
        {
            return this._chatFontSizeMode;
        }
public function  set_chatFontSizeMode(k:Int):Int        {
            this._chatFontSizeMode = this.clampChatFontSizeMode(k);
            this._communication.connection.send(new SetChatStylePreferenceComposer(this._preferedChatStyle, this._chatFontSizeMode));
return k;
        }

        public var chatFontSizeScale(get,never):Float;
public function  get_chatFontSizeScale():Float
        {
            switch (this._chatFontSizeMode)
            {
                case 1:
                    return 1.15;
                case 2:
                    return 1.3;
                case 3:
                    return 1.5;
                case 4:
                    return 1.75;
                default:
                    return 1;
            }
        }

        function clampChatFontSizeMode(k:Int):Int
        {
            if (k < 0)
            {
                return 0;
            }
            if (k > 4)
            {
                return 4;
            }
            return k;
        }

        function fixHtml(k:ChatItem, _arg_2:ChatStyle)
        {
            var _local_3:UInt = 0;
            if (!_arg_2.allowHTML)
            {
                k.text = new compat.RegExp(">", "g").replace(new compat.RegExp("<", "g").replace(k.text, "&lt;"), "&gt;");
                k.text = new compat.RegExp("&#[0-9]+;", "g").replace(k.text, "");
                k.text = new compat.RegExp("&#x[0-9]+;", "g").replace(k.text, "");
            }
            _local_3 = ASCompat.toUInt((((_arg_2.textFormat != null) && (!(_arg_2.textFormat.color == null))) ? ASCompat.toUInt(_arg_2.textFormat.color) : 0));
            if (_arg_2.isNotification)
            {
                k.text = ChatMarkup.applyToElements(k.text, _local_3);
            }
            k.text = ChatMarkup.applyColourToChat(k.text, _local_3);
        }

        public function isNotificationStyle(k:Int):Bool
        {
            var _local_2= Std.downcast(this.chatStyleLibrary.getStyle(k) , ChatStyle);
            return ((_local_2 != null) && _local_2.isNotification);
        }

        public function clear()
        {
            if (this._chatFlowStage != null)
            {
                this._chatFlowStage.clear();
            }
        }

        public function toggleVisibility()
        {
            if (((this.isDisabledInPreferences || (!this._perkAllowed)) || (!(this._chatHistoryPulldown != null))))
            {
                return;
            }
            this._chatHistoryPulldown._Str_19537();
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }
    }

